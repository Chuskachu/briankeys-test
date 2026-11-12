import UIKit

/// BrianKeys — Brian's own keyboard, built with him, for his thumbs.
///
/// Design rules, from Brian's pain-point map:
/// - Big, clearly separated keys for wide thumb contact patches.
/// - Spanish QWERTY; Ñ lives on long-press N (Brian's call — no Ñ key).
///   Accents and digits also live on long-press (a big variants strip
///   appears at the top — no tiny floating popups).
/// - Haptics are our road to "feeling" the keys (Brian's insight): the
///   software echo of the BlackBerry's physical edges. V1.7: families are
///   distinguished by PATTERN, not intensity — V1.6's light@0.6 letters
///   were indistinguishable from everything else; only heavy space stood
///   out. Letters = one firm medium pulse, space = heavy DOUBLE pulse,
///   delete = rigid, return = heavy single. Generators re-prepare after
///   every fire so the pulse lands WITH the touch, not after it.
/// - Return key is buffered: a dead gap before it + its own colour,
///   because Brian kept hitting it when aiming for space or delete.
/// - NO autocorrect, ever. The keyboard inserts exactly what he taps;
///   the suggestion bar only OFFERS completions — tapping one is his
///   choice, nothing is ever forced (V1.7, Phase 2 pulled forward).
/// - Shift: tap = one capital, double-tap = caps lock, auto-on after ". ".
///
/// Input model (V1.5–V1.7): letters commit on touch DOWN (touch-up lost
/// too many letters at Brian's speed), dragging into another typing key
/// commits it too (slide-commit, V1.6), and V1.7 adds a proximity rescue:
/// a touch that begins in the dead gap BETWEEN keys is assigned by the
/// view controller to the nearest typing key — there are no dead zones.
/// Dangerous keys (return, delete, shift, mode) are NEVER assigned by
/// proximity; they only fire on a direct hit.

private class KeyButton: UIButton {
    enum Haptic { case lightKey, heavySpace, rigidDelete, mediumReturn, select }
    var variants: [String] = []
    var isShiftKey = false
    var isDeleteKey = false
    var isSpaceKey = false
    var haptic: Haptic = .lightKey
    var hitExpand: CGFloat = 0
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard hitExpand > 0 else { return super.point(inside: point, with: event) }
        return bounds.insetBy(dx: -hitExpand, dy: 0).contains(point)
    }

    // Slide-commit ("el arrastre escribe", V1.6). Brian's own diagnosis:
    // at speed he drags his finger across keys without lifting, and every
    // key after the first was silently lost. When a touch drags well INTO
    // another typing key, that key commits too — once per key per touch.
    // Function keys are never slide targets: a glide must not delete or
    // submit by accident.
    static var slideTargets: [KeyButton] = []
    var slideEnabled = false
    var onSlideCommit: ((KeyButton) -> Void)?
    private var slidCommitted: Set<ObjectIdentifier> = []

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        slidCommitted = [ObjectIdentifier(self)]
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard slideEnabled, let touch = touches.first, let handler = onSlideCommit else { return }
        let p = touch.location(in: nil)   // window coordinates
        for target in KeyButton.slideTargets {
            let id = ObjectIdentifier(target)
            if slidCommitted.contains(id) { continue }
            // Must be well inside the target, not just grazing its edge.
            let f = target.convert(target.bounds, to: nil).insetBy(dx: 6, dy: 5)
            if f.contains(p) {
                slidCommitted.insert(id)
                handler(target)
            }
        }
    }
}

class KeyboardViewController: UIInputViewController {

    private enum Mode { case letters, numbers, symbols }
    private enum Shift { case off, once, locked }

    private var mode: Mode = .letters
    private var shift: Shift = .once

    private var mainStack: UIStackView!
    private var variantStrip: UIStackView!
    private var deleteTimer: Timer?
    private var heightConstraint: NSLayoutConstraint!
    private var lastShiftTap: Date?

    // Haptics — see the header. Pattern over intensity (V1.7).
    private let hapticLight = UIImpactFeedbackGenerator(style: .light)
    private let hapticMedium = UIImpactFeedbackGenerator(style: .medium)
    private let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let hapticRigid = UIImpactFeedbackGenerator(style: .rigid)
    private let hapticSelect = UISelectionFeedbackGenerator()
    private var letterButtons: [KeyButton] = []
    private var shiftButton: KeyButton?
    /// The key whose character was just inserted on touch-down, so a
    /// long-press variant can replace it (delete + insert variant).
    private weak var pendingVariantKey: KeyButton?
    /// All keys a finger may slide-commit into on the current page.
    /// Exactly the typing keys — function keys are never in this list,
    /// which is also what makes the proximity rescue safe.
    private var slideKeys: [KeyButton] = []
    /// When the last single space was typed, for double-space → ". ".
    private var lastSpaceAt: Date?
    private var popupLabel: UILabel?
    /// V1.7 proximity rescue: touches that began in a dead gap, tracked
    /// per touch with the keys they have already committed.
    private var rescuedTouches: [ObjectIdentifier: Set<ObjectIdentifier>] = [:]

    // MARK: - Suggestion bar (V1.7 — Phase 2, pulled forward by Brian)
    //
    // Completion only, never correction: up to 3 chips above the keys.
    // Sources, in priority order: (1) Brian's personal seed words,
    // (2) words the keyboard has LEARNED from his own typing (counted
    // when he completes them), (3) frequency-ordered ES and EN lists.
    // Matching ignores accents and case, so typing "alegr" offers
    // "alegría" — the accented form he skips at speed. Tapping a chip
    // replaces the current partial word and adds a space. Nothing is
    // ever inserted without his tap.

    private var suggestionBar: UIStackView!
    private var chips: [UIButton] = []
    private var currentSuggestions: [String] = []

    /// His own words — in no dictionary, top priority (design phase 3
    /// seeds; the in-app manager comes later).
    private let seedWords = ["chumaleeee", "wokiii", "tamos", "contat",
                             "cheverazo", "monasho", "Naná", "Rocío", "Leo",
                             "pelucha", "Pelusa", "kakachon"]
    private let learnedKey = "bk_learned_v1"
    private lazy var learned: [String: Int] = {
        UserDefaults.standard.dictionary(forKey: learnedKey) as? [String: Int] ?? [:]
    }()

    // MARK: - Corrección prudente (V1.8 — Brian's choice, 2026-11-12)
    //
    // Registration alone hit a physical wall: Brian's thumb patch covers
    // two keys, so intent is not in the touch signal. His answer: an
    // AUTOMATIC corrector, but a prudent one, under HIS rules:
    // - It only touches words that exist in NEITHER Spanish nor English.
    // - It acts only when there is exactly ONE plausible candidate.
    // - His words (seeds, and anything learned twice) are untouchable.
    // - It ships OFF; he switches it with a long-press on the space bar
    //   (the switch lives in the keyboard: app↔extension settings need
    //   App Groups, unproven under SideStore re-signing).
    // Every fix announces itself with a soft double-tick haptic so he can
    // FEEL the keyboard act — transparency he can notice, never silent.
    private let prudentKey = "bk_prudent_v1"
    private lazy var prudentEnabled: Bool = UserDefaults.standard.bool(forKey: prudentKey)
    private lazy var foldedESSet: Set<String> = Set(foldedES)
    private lazy var foldedENSet: Set<String> = Set(foldedEN)
    private lazy var foldedES: [String] = WordLists.es.map { fold($0) }
    private lazy var foldedEN: [String] = WordLists.en.map { fold($0) }
    private lazy var foldedSeeds: [String] = seedWords.map { fold($0) }

    private func fold(_ s: String) -> String {
        s.lowercased().folding(options: .diacriticInsensitive, locale: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hapticLight.prepare()
        hapticMedium.prepare()
        hapticHeavy.prepare()
        hapticRigid.prepare()
        hapticSelect.prepare()

        heightConstraint = NSLayoutConstraint(item: view!, attribute: .height,
                                        relatedBy: .equal, toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: 315)
        heightConstraint.priority = UILayoutPriority(999)
        view.addConstraint(heightConstraint)

        mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.distribution = .fill
        mainStack.spacing = 7
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4)
        ])

        // The suggestion bar is a persistent view, re-added on every
        // rebuild (clearStack wipes the stack's arranged subviews).
        suggestionBar = UIStackView()
        suggestionBar.axis = .horizontal
        suggestionBar.distribution = .fillEqually
        suggestionBar.spacing = 6
        suggestionBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        chips = (0..<3).map { i in
            let c = UIButton(type: .system)
            c.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            c.setTitleColor(.label, for: .normal)
            c.backgroundColor = keyColor
            c.layer.cornerRadius = 8
            c.tag = i
            c.addTarget(self, action: #selector(chipTapped(_:)), for: .touchUpInside)
            suggestionBar.addArrangedSubview(c)
            return c
        }

        buildKeyboard()
    }

    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        autoShiftIfNeeded()
        updateSuggestions()
    }

    // MARK: - Keyboard construction

    private func clearStack() {
        for arranged in mainStack.arrangedSubviews {
            mainStack.removeArrangedSubview(arranged)
            arranged.removeFromSuperview()
        }
    }

    private func buildKeyboard() {
        clearStack()
        slideKeys = []

        mainStack.addArrangedSubview(suggestionBar)

        // Variants strip (hidden until a long-press).
        variantStrip = UIStackView()
        variantStrip.axis = .horizontal
        variantStrip.distribution = .fillEqually
        variantStrip.spacing = 5
        variantStrip.isHidden = true
        variantStrip.heightAnchor.constraint(equalToConstant: 46).isActive = true
        mainStack.addArrangedSubview(variantStrip)

        switch mode {
        case .letters: buildLetters()
        case .numbers: buildNumbers()
        case .symbols: buildSymbols()
        }
        // V1.8: space is NOT a slide target anymore. V1.7 data showed a
        // space sneaking in before commas and question marks — his drag
        // toward the punctuation clipped the space bar on the way past.
        // Space still commits on direct touch (and via proximity rescue,
        // which reads slideKeys, not slideTargets).
        KeyButton.slideTargets = slideKeys.filter { !$0.isSpaceKey }
        updateSuggestions()
    }

    // Key colours with real separation in dark mode too.
    private var keyColor: UIColor {
        UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1)
            : .secondarySystemBackground }
    }
    private var functionKeyColor: UIColor {
        UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1)
            : .tertiarySystemBackground }
    }
    // Pressed-state colours: keys visibly react the instant they are
    // touched — part of "responde lento" was that nothing SEEMED to happen.
    private var keyPressedColor: UIColor {
        UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.38, green: 0.38, blue: 0.42, alpha: 1)
            : .systemGray4 }
    }
    private var functionPressedColor: UIColor {
        UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.26, green: 0.26, blue: 0.29, alpha: 1)
            : .systemGray3 }
    }

    private func solidImage(_ color: UIColor) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { ctx in
            color.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

    /// Paint a key with 1x1 colour images so the .highlighted state can
    /// differ — a plain backgroundColor cannot express "pressed".
    private func paint(_ b: KeyButton, normal: UIColor, pressed: UIColor) {
        b.setBackgroundImage(solidImage(normal), for: .normal)
        b.setBackgroundImage(solidImage(pressed), for: .highlighted)
        b.backgroundColor = nil
        b.layer.masksToBounds = true
    }

    private func makeRow(_ keys: [KeyButton], equal: Bool = true) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        // .fillEqually for uniform key rows: with plain .fill the stack gives
        // ALL spare width to the first key (V1.1 bug: giant Q and A keys).
        row.distribution = equal ? .fillEqually : .fill
        row.spacing = 6
        row.heightAnchor.constraint(equalToConstant: 56).isActive = true
        for key in keys { row.addArrangedSubview(key) }
        return row
    }

    private func letterKey(_ char: String, variants: [String] = []) -> KeyButton {
        let display = (shift == .off) ? char : char.uppercased()
        let b = KeyButton(type: .system)
        b.setTitle(display, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        b.setTitleColor(.label, for: .normal)
        paint(b, normal: keyColor, pressed: keyPressedColor)
        b.layer.cornerRadius = 10
        b.variants = variants
        b.haptic = .lightKey
        b.accessibilityLabel = char
        // Letters register on touch DOWN, not touch-up (V1.5): at Brian's
        // speed the thumb lands, slides a hair, and lifts outside the key,
        // so touchUpInside never fired. Fast keyboards commit on contact.
        b.addTarget(self, action: #selector(letterTouchedDown(_:)), for: .touchDown)
        b.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        // This key can also be typed by dragging into it (V1.6).
        b.slideEnabled = true
        b.onSlideCommit = { [weak self] target in self?.slideCommit(target) }
        slideKeys.append(b)
        if !variants.isEmpty { addLongPress(to: b) }
        return b
    }

    private func functionKey(_ title: String, action: Selector, flex: CGFloat = 1.0) -> KeyButton {
        let b = KeyButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        b.setTitleColor(.label, for: .normal)
        paint(b, normal: functionKeyColor, pressed: functionPressedColor)
        b.layer.cornerRadius = 10
        b.haptic = .select
        b.addTarget(self, action: action, for: .touchUpInside)
        b.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        b.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return b
    }

    @objc private func keyTouchedDown(_ sender: KeyButton) {
        // V1.7 haptics by PATTERN (see header). Every fire re-prepares its
        // generator: an unprepared generator answers late, and a late
        // pulse reads as a slow keyboard even when the letter landed.
        switch sender.haptic {
        case .lightKey:   // letters & punctuation: one clear pulse
            // V1.8: V1.7's full-strength 1.0 felt TOO strong (Brian) —
            // the pattern was right, the volume was not.
            hapticMedium.impactOccurred(intensity: 0.65)
            hapticMedium.prepare()
        case .heavySpace: // space: heavy DOUBLE pulse — unmistakable
            hapticHeavy.impactOccurred(intensity: 0.85)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) { [weak self] in
                self?.hapticHeavy.impactOccurred(intensity: 0.55)
                self?.hapticHeavy.prepare()
            }
            hapticHeavy.prepare()
        case .rigidDelete:
            hapticRigid.impactOccurred(intensity: 0.75)
            hapticRigid.prepare()
        case .mediumReturn:
            hapticHeavy.impactOccurred(intensity: 0.85)
            hapticHeavy.prepare()
        case .select:
            hapticSelect.selectionChanged()
            hapticSelect.prepare()
        }
    }

    private func addLongPress(to button: KeyButton) {
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        lp.minimumPressDuration = 0.35
        button.addGestureRecognizer(lp)
    }

    // MARK: Letters page

    private func buildLetters() {
        letterButtons = []
        let digits = ["1","2","3","4","5","6","7","8","9","0"]
        let row1Letters = ["q","w","e","r","t","y","u","i","o","p"]
        var row1: [KeyButton] = []
        for (i, ch) in row1Letters.enumerated() {
            var v = [digits[i]]
            switch ch {
            case "e": v.append("é")
            case "u": v.append(contentsOf: ["ú", "ü"])
            case "i": v.append("í")
            case "o": v.append("ó")
            default: break
            }
            let k = letterKey(ch, variants: v)
            row1.append(k); letterButtons.append(k)
        }
        mainStack.addArrangedSubview(makeRow(row1))

        var row2: [KeyButton] = []
        for ch in ["a","s","d","f","g","h","j","k","l"] {
            var v: [String] = []
            if ch == "a" { v = ["á"] }
            let k = letterKey(ch, variants: v)
            // L was dropped in 4 of 7 V1.4 test texts — it sits at the row's
            // right edge where Brian's wide thumb makes partial contact.
            // Give it a bigger invisible net (steals a slice from K's edge).
            // (The V1.7 proximity rescue also assigns it the screen edge.)
            if ch == "l" { k.hitExpand = 6 }
            row2.append(k); letterButtons.append(k)
        }
        mainStack.addArrangedSubview(makeRow(row2))

        // Row 3: SHIFT | z x c v b n m | DELETE — every cell the same size
        // (Brian's call, V1.5): a uniform grid, BlackBerry-style.
        let shiftBtn = functionKey(shift == .off ? "⇧" : "⇪", action: #selector(shiftTapped(_:)))
        shiftBtn.isShiftKey = true
        if shift != .off { paint(shiftBtn, normal: .systemOrange, pressed: .systemOrange) }
        shiftButton = shiftBtn
        var row3: [KeyButton] = [shiftBtn]
        for ch in ["z","x","c","v","b","n","m"] {
            // Brian's call: no Ñ key — Ñ lives on long-press N instead.
            let k = letterKey(ch, variants: ch == "n" ? ["ñ"] : [])
            row3.append(k); letterButtons.append(k)
        }
        let del = functionKey("⌫", action: #selector(deleteTapped))
        del.isDeleteKey = true
        del.haptic = .rigidDelete
        addDeleteHold(to: del)
        row3.append(del)
        mainStack.addArrangedSubview(makeRow(row3))

        mainStack.addArrangedSubview(bottomRow(modeTitle: "123", modeAction: #selector(showNumbers)))
    }

    // MARK: Numbers page

    private func buildNumbers() {
        mainStack.addArrangedSubview(makeRow("1234567890".map { letterKey(String($0)) }))
        mainStack.addArrangedSubview(makeRow(["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""].map { punctKey($0) }))
        var row3: [KeyButton] = [functionKey("#+=", action: #selector(showSymbols))]
        for ch in [".", ",", "?", "!", "'"] { row3.append(punctKey(ch)) }
        let del = functionKey("⌫", action: #selector(deleteTapped))
        del.isDeleteKey = true
        del.haptic = .rigidDelete
        addDeleteHold(to: del)
        row3.append(del)
        mainStack.addArrangedSubview(makeRow(row3))
        mainStack.addArrangedSubview(bottomRow(modeTitle: "ABC", modeAction: #selector(showLetters)))
    }

    // MARK: Symbols page

    private func buildSymbols() {
        mainStack.addArrangedSubview(makeRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="].map { punctKey($0) }))
        mainStack.addArrangedSubview(makeRow(["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"].map { punctKey($0) }))
        var row3: [KeyButton] = [functionKey("123", action: #selector(showNumbers))]
        for ch in [".", ",", "?", "!", "'"] { row3.append(punctKey(ch)) }
        let del = functionKey("⌫", action: #selector(deleteTapped))
        del.isDeleteKey = true
        del.haptic = .rigidDelete
        addDeleteHold(to: del)
        row3.append(del)
        mainStack.addArrangedSubview(makeRow(row3))
        mainStack.addArrangedSubview(bottomRow(modeTitle: "ABC", modeAction: #selector(showLetters)))
    }

    private func punctKey(_ char: String) -> KeyButton {
        letterKey(char)   // letterKey already paints it as a typing key
    }

    // MARK: Bottom row (shared)

    private func bottomRow(modeTitle: String, modeAction: Selector) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = 6
        row.heightAnchor.constraint(equalToConstant: 56).isActive = true

        // NO globe key (V1.3, Brian: "ese logo del mundo molesta"). It sat
        // in his left thumb's travel path and an accidental tap teleported
        // him to Apple's keyboard mid-word. iOS draws its own globe in the
        // chin below the keyboard, so switching still works when HE wants.
        let modeBtn = functionKey(modeTitle, action: modeAction)
        // V1.6 (Brian): the 123 button was much too big — shrink it so the
        // space bar can grow.
        modeBtn.widthAnchor.constraint(equalToConstant: 38).isActive = true
        row.addArrangedSubview(modeBtn)

        let comma = punctKey(",")
        comma.variants = [".", "?", "!", "¿", "¡"]
        addLongPress(to: comma)
        comma.widthAnchor.constraint(equalToConstant: 36).isActive = true
        row.addArrangedSubview(comma)

        let space = KeyButton(type: .system)
        space.setTitle("space", for: .normal)
        space.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        space.setTitleColor(.label, for: .normal)
        paint(space, normal: keyColor, pressed: keyPressedColor)
        space.layer.cornerRadius = 10
        space.haptic = .heavySpace
        space.isSpaceKey = true
        space.hitExpand = 8   // space "steals" a few points from its neighbours' edges
        space.addTarget(self, action: #selector(spaceTapped), for: .touchDown)   // commit on contact, like the letters
        space.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        // V1.8: long-press space = the prudent corrector's ON/OFF switch.
        let spaceLP = UILongPressGestureRecognizer(target: self, action: #selector(spaceLongPressed(_:)))
        spaceLP.minimumPressDuration = 0.4
        space.addGestureRecognizer(spaceLP)
        // Dragging into space also types a space (V1.6).
        space.slideEnabled = true
        space.onSlideCommit = { [weak self] target in self?.slideCommit(target) }
        slideKeys.append(space)
        row.addArrangedSubview(space)

        let period = punctKey(".")
        period.variants = [",", "?", "!", "¿", "¡", "…"]
        addLongPress(to: period)
        period.widthAnchor.constraint(equalToConstant: 36).isActive = true
        row.addArrangedSubview(period)

        // The buffer before Return (Brian's danger zone). V1.7: 10→4pt —
        // Brian spotted the wasted space in his own screenshot and asked
        // for a longer space bar ("todo ayuda"). A sliver stays: proximity
        // never assigns Return anyway, so the gap is now just insurance
        // for a direct hit drifting right.
        let gap = UIView()
        gap.widthAnchor.constraint(equalToConstant: 4).isActive = true
        row.addArrangedSubview(gap)

        let ret = KeyButton(type: .system)
        ret.setTitle("⏎", for: .normal)
        ret.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        ret.setTitleColor(.label, for: .normal)
        paint(ret, normal: UIColor.systemTeal.withAlphaComponent(0.35),
              pressed: UIColor.systemTeal.withAlphaComponent(0.6))
        ret.layer.cornerRadius = 10
        ret.haptic = .mediumReturn
        ret.widthAnchor.constraint(equalToConstant: 44).isActive = true
        ret.addTarget(self, action: #selector(returnTapped), for: .touchUpInside)
        ret.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        row.addArrangedSubview(ret)

        return row
    }

    // MARK: - Variants strip

    @objc private func longPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began, let b = gesture.view as? KeyButton, !b.variants.isEmpty else { return }
        showVariants(for: b)
    }

    private func showVariants(for button: KeyButton) {
        for arranged in variantStrip.arrangedSubviews {
            variantStrip.removeArrangedSubview(arranged)
            arranged.removeFromSuperview()
        }
        for variant in button.variants {
            let vb = UIButton(type: .system)
            vb.setTitle(variant, for: .normal)
            vb.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
            vb.setTitleColor(.label, for: .normal)
            vb.backgroundColor = .systemOrange.withAlphaComponent(0.30)
            vb.layer.cornerRadius = 8
            vb.addTarget(self, action: #selector(variantTapped(_:)), for: .touchUpInside)
            variantStrip.addArrangedSubview(vb)
        }
        let close = UIButton(type: .system)
        close.setTitle("✕", for: .normal)
        close.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        close.setTitleColor(.label, for: .normal)
        close.backgroundColor = .tertiarySystemBackground
        close.layer.cornerRadius = 8
        close.addTarget(self, action: #selector(hideVariants), for: .touchUpInside)
        variantStrip.addArrangedSubview(close)
        variantStrip.isHidden = false
        heightConstraint.constant = 368
    }

    @objc private func hideVariants() {
        variantStrip.isHidden = true
        heightConstraint.constant = 315
    }

    @objc private func variantTapped(_ sender: UIButton) {
        guard let s = sender.title(for: .normal) else { return }
        hapticMedium.impactOccurred(intensity: 1.0)
        hapticMedium.prepare()
        // The base character was already inserted on touch-down (V1.5);
        // choosing a variant REPLACES it instead of adding a second char.
        if pendingVariantKey != nil {
            textDocumentProxy.deleteBackward()
            pendingVariantKey = nil
        }
        insertTextSmart(s)
        hideVariants()
    }

    // MARK: - Suggestion engine

    /// The word currently being typed: the run of letters right before
    /// the cursor ("" right after a space or punctuation mark).
    private func currentWord() -> String {
        let context = textDocumentProxy.documentContextBeforeInput ?? ""
        var word = ""
        for ch in context.reversed() {
            if ch.isLetter { word.insert(ch, at: word.startIndex) } else { break }
        }
        return word
    }

    /// Count a word so the bar learns Brian's vocabulary.
    private func learn(_ w: String) {
        guard w.count >= 2 else { return }
        learned[w, default: 0] += 1
        if learned.count > 800 {   // keep the store lean: top 400 survive
            learned = Dictionary(uniqueKeysWithValues:
                learned.sorted { $0.value > $1.value }.prefix(400).map { ($0.key, $0.value) })
        }
        UserDefaults.standard.set(learned, forKey: learnedKey)
    }

    /// A word was just completed (space / punctuation / return): first
    /// let the prudent corrector judge it, then learn the FINAL form —
    /// a corrected word reinforces its correction, and the raw typo is
    /// never learned.
    private func completeWord() {
        let w = currentWord()
        guard w.count >= 2 else { return }
        var final = w
        if prudentEnabled, let fixed = prudentFix(for: w) {
            replaceCurrentWord(with: fixed)
            final = fixed
            // The corrector's signature: two soft ticks — "I acted".
            hapticLight.impactOccurred(intensity: 0.7)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) { [weak self] in
                self?.hapticLight.impactOccurred(intensity: 0.7)
                self?.hapticLight.prepare()
            }
        }
        learn(final)
    }

    /// The prudent judge. Returns the ONE acceptable correction for a
    /// non-word, or nil — nil is its favourite answer.
    private func prudentFix(for w: String) -> String? {
        guard w.count >= 4 else { return nil }
        // All-caps words are acronyms and intentions, not typos.
        if w == w.uppercased() { return nil }
        let fw = fold(w)
        // It must be a NON-WORD in both languages (accents/case folded —
        // "alegria" IS "alegría" minus effort; the chips offer the accent).
        if foldedESSet.contains(fw) || foldedENSet.contains(fw) { return nil }
        // His seeds are sacred.
        if foldedSeeds.contains(fw) { return nil }
        // A learned word he has completed twice is vocabulary, not error.
        // (Once could be a typo; twice is a choice.)
        for (surface, count) in learned where count >= 2 && fold(surface) == fw { return nil }
        // Candidate pool: his words first, then the top of both lists.
        let budget = w.count >= 7 ? 2 : 1
        var candidates: [String] = []
        func consider(_ surface: String, _ foldedForm: String) {
            let d = osaDistance(fw, foldedForm, maxDist: budget)
            if d == 0 { candidates.append("\u{0}EXACT") ; return }  // folded-equal = it IS a word
            if d <= budget { candidates.append(surface) }
        }
        for (i, seed) in seedWords.enumerated() { consider(seed, foldedSeeds[i]) }
        for (surface, _) in learned { consider(surface, fold(surface)) }
        for i in 0..<min(1200, WordLists.es.count) { consider(WordLists.es[i], foldedES[i]) }
        for i in 0..<min(1200, WordLists.en.count) { consider(WordLists.en[i], foldedEN[i]) }
        if candidates.contains("\u{0}EXACT") { return nil }
        // Act only on a UNIQUE candidate — two plausible fixes = no fix.
        let unique = Array(Set(candidates))
        guard unique.count == 1, var fixed = unique.first else { return nil }
        // Keep his capitalisation.
        if let first = w.first, first.isUppercase {
            fixed = fixed.prefix(1).uppercased() + fixed.dropFirst()
        }
        return fixed
    }

    /// Optimal string alignment distance (Levenshtein + transposition
    /// counts as ONE edit — "borwn" is one slip away from "brown"),
    /// with early exit once the distance provably exceeds maxDist.
    private func osaDistance(_ a: String, _ b: String, maxDist: Int) -> Int {
        let x = Array(a), y = Array(b)
        if abs(x.count - y.count) > maxDist { return maxDist + 1 }
        var prev2: [Int]? = nil
        var prev = Array(0...y.count)
        var cur = [Int](repeating: 0, count: y.count + 1)
        for i in 1...x.count {
            cur[0] = i
            var rowMin = cur[0]
            for j in 1...y.count {
                let cost = x[i - 1] == y[j - 1] ? 0 : 1
                cur[j] = min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + cost)
                if i > 1, j > 1, x[i - 1] == y[j - 2], x[i - 2] == y[j - 1], let p2 = prev2 {
                    cur[j] = min(cur[j], p2[j - 2] + 1)
                }
                rowMin = min(rowMin, cur[j])
            }
            if rowMin > maxDist { return maxDist + 1 }
            prev2 = prev
            prev = cur
            cur = [Int](repeating: 0, count: y.count + 1)
        }
        return prev[y.count]
    }

    private func replaceCurrentWord(with fixed: String) {
        let w = currentWord()
        for _ in w { textDocumentProxy.deleteBackward() }
        textDocumentProxy.insertText(fixed)
    }

    /// Long-press on space: the prudent corrector's switch + a flash in
    /// the bar so he SEES the state change.
    @objc private func spaceLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        prudentEnabled.toggle()
        UserDefaults.standard.set(prudentEnabled, forKey: prudentKey)
        hapticSelect.selectionChanged()
        chips[0].setTitle("Corrección prudente", for: .normal)
        chips[1].setTitle(prudentEnabled ? "ACTIVADA ✓" : "apagada", for: .normal)
        chips[2].setTitle("", for: .normal)
        for c in chips { c.isEnabled = false; c.alpha = 1 }
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(refreshBar),
                                               object: nil)
        perform(#selector(refreshBar), with: nil, afterDelay: 1.4)
    }

    @objc private func refreshBar() { updateSuggestions() }

    private func computeSuggestions(for prefix: String) -> [String] {
        if prefix.isEmpty {
            // No word in progress: offer his most-used learned words.
            return learned.sorted { $0.value > $1.value }.prefix(3).map { $0.key }
        }
        let fp = fold(prefix)
        var out: [String] = []
        var seen = Set<String>()
        func offer(_ surface: String) {
            let f = fold(surface)
            guard !seen.contains(f) else { return }
            seen.insert(f)
            out.append(surface)
        }
        for (i, seed) in seedWords.enumerated() where foldedSeeds[i].hasPrefix(fp) {
            offer(seed)
            if out.count == 3 { return out }
        }
        let learnedMatches = learned
            .filter { fold($0.key).hasPrefix(fp) }
            .sorted { $0.value > $1.value }
        for m in learnedMatches {
            offer(m.key)
            if out.count == 3 { return out }
        }
        for (i, w) in WordLists.es.enumerated() where foldedES[i].hasPrefix(fp) {
            offer(w)
            if out.count == 3 { return out }
        }
        for (i, w) in WordLists.en.enumerated() where foldedEN[i].hasPrefix(fp) {
            offer(w)
            if out.count == 3 { return out }
        }
        return out
    }

    private func updateSuggestions() {
        guard suggestionBar != nil else { return }
        currentSuggestions = computeSuggestions(for: currentWord())
        for (i, chip) in chips.enumerated() {
            if i < currentSuggestions.count {
                chip.setTitle(currentSuggestions[i], for: .normal)
                chip.isEnabled = true
                chip.alpha = 1
            } else {
                chip.setTitle("", for: .normal)
                chip.isEnabled = false
                chip.alpha = 0.35
            }
        }
    }

    @objc private func chipTapped(_ sender: UIButton) {
        let i = sender.tag
        guard i < currentSuggestions.count else { return }
        var word = currentSuggestions[i]
        let partial = currentWord()
        for _ in partial { textDocumentProxy.deleteBackward() }
        if shift != .off {
            word = word.prefix(1).uppercased() + word.dropFirst()
            if shift == .once { shift = .off; applyShiftVisuals() }
        }
        textDocumentProxy.insertText(word)
        learn(word)
        textDocumentProxy.insertText(" ")
        lastSpaceAt = nil
        autoShiftIfNeeded()
        updateSuggestions()
    }

    // MARK: - Proximity rescue (V1.7)
    //
    // Buttons only hear touches that BEGIN on them. A wide thumb landing
    // in the 6pt gap between keys began on NO button, and the whole touch
    // (including its slide) was lost — the likely source of the dropped
    // letters that survived touch-down commit. Touches that begin on a
    // non-button view bubble up the responder chain to here; we assign
    // them to the nearest TYPING key (slideKeys — function keys are not
    // in that list, so a rescued touch can never delete or hit return).

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            if touch.view is UIButton { continue }   // buttons handle themselves
            let p = touch.location(in: nil)
            // Never rescue from the suggestion bar or the variants strip:
            // a brush across them must not rain letters from the top row.
            if suggestionBar != nil, suggestionBar.window != nil,
               suggestionBar.convert(suggestionBar.bounds, to: nil).contains(p) { continue }
            if variantStrip != nil, !variantStrip.isHidden, variantStrip.window != nil,
               variantStrip.convert(variantStrip.bounds, to: nil).contains(p) { continue }
            guard let key = nearestTypingKey(to: p, strict: false) else { continue }
            rescuedTouches[ObjectIdentifier(touch)] = [ObjectIdentifier(key)]
            slideCommit(key)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            let id = ObjectIdentifier(touch)
            guard var done = rescuedTouches[id] else { continue }
            let p = touch.location(in: nil)
            guard let key = nearestTypingKey(to: p, strict: true),
                  !done.contains(ObjectIdentifier(key)) else { continue }
            done.insert(ObjectIdentifier(key))
            rescuedTouches[id] = done
            slideCommit(key)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches { rescuedTouches.removeValue(forKey: ObjectIdentifier(touch)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        for touch in touches { rescuedTouches.removeValue(forKey: ObjectIdentifier(touch)) }
    }

    /// strict=false (touch began): a key whose slightly-expanded frame
    /// holds the point wins; otherwise the nearest key centre within
    /// 36pt. strict=true (sliding): the point must be well inside the key.
    private func nearestTypingKey(to p: CGPoint, strict: Bool) -> KeyButton? {
        var best: KeyButton?
        var bestDist = CGFloat.greatestFiniteMagnitude
        for key in slideKeys where key.window != nil {
            let f = key.convert(key.bounds, to: nil)
            if strict {
                if f.insetBy(dx: 6, dy: 5).contains(p) { return key }
            } else if f.insetBy(dx: -5, dy: -3).contains(p) {
                let d = hypot(f.midX - p.x, f.midY - p.y)
                if d < bestDist { bestDist = d; best = key }
            }
        }
        if strict || best != nil { return best }
        for key in slideKeys where key.window != nil {
            let f = key.convert(key.bounds, to: nil)
            let d = hypot(f.midX - p.x, f.midY - p.y)
            if d < bestDist { bestDist = d; best = key }
        }
        return bestDist <= 36 ? best : nil
    }

    // MARK: - Actions

    private func insertTextSmart(_ text: String) {
        if text.count == 1, let c = text.first, !c.isLetter, c != " " {
            completeWord()   // a punctuation mark completes a word
        }
        lastSpaceAt = nil   // any real character breaks a double-space chain
        var out = text
        if text.count == 1, text.first!.isLetter {
            out = (shift == .off) ? text.lowercased() : text.uppercased()
        }
        textDocumentProxy.insertText(out)
        if shift == .once, text.count == 1, text.first!.isLetter {
            shift = .off
            applyShiftVisuals()   // update in place — never rebuild mid-typing
        }
        updateSuggestions()
    }

    /// Shift visuals WITHOUT rebuilding the keyboard. V1.2 rebuilt the
    /// whole view on every shift change and auto-shift check, and those
    /// rebuilds swallowed touches while Brian typed fast.
    private func applyShiftVisuals() {
        for b in letterButtons {
            guard let base = b.accessibilityLabel else { continue }
            b.setTitle(shift == .off ? base : base.uppercased(), for: .normal)
        }
        shiftButton?.setTitle(shift == .off ? "⇧" : "⇪", for: .normal)
        if let sb = shiftButton {
            if shift == .off { paint(sb, normal: functionKeyColor, pressed: functionPressedColor) }
            else { paint(sb, normal: .systemOrange, pressed: .systemOrange) }
        }
    }

    @objc private func letterTouchedDown(_ sender: KeyButton) {
        guard let label = sender.accessibilityLabel ?? sender.title(for: .normal) else { return }
        insertTextSmart(label)
        pendingVariantKey = sender   // a long-press variant may replace this char
        showPopup(for: sender)
    }

    /// A drag (or a rescued gap touch) entered this key — type it as if
    /// tapped. Only typing keys are ever passed here.
    private func slideCommit(_ target: KeyButton) {
        guard variantStrip == nil || variantStrip.isHidden else { return }
        keyTouchedDown(target)   // the target family's own haptic
        if target.isSpaceKey {
            spaceTapped()
        } else if let label = target.accessibilityLabel ?? target.title(for: .normal) {
            insertTextSmart(label)
            pendingVariantKey = target
            showPopup(for: target)
        }
    }

    /// The classic key popup: the letter, enlarged, above the key — visual
    /// proof the key registered. V1.7 diet: ONE reused label, no fade
    /// animation (an animation per keystroke was pure main-thread cost).
    private func showPopup(for key: KeyButton) {
        guard let text = key.title(for: .normal) ?? key.accessibilityLabel,
              !text.isEmpty, text.count <= 2, key.window != nil else { return }
        let l: UILabel
        if let existing = popupLabel {
            l = existing
        } else {
            l = UILabel()
            l.font = .systemFont(ofSize: 30, weight: .medium)
            l.textAlignment = .center
            l.layer.cornerRadius = 8
            l.layer.borderWidth = 0.5
            l.layer.borderColor = UIColor.separator.cgColor
            l.layer.masksToBounds = true
            popupLabel = l
        }
        l.text = text
        l.backgroundColor = keyPressedColor
        l.alpha = 1
        let kf = key.convert(key.bounds, to: view)
        l.frame = CGRect(x: kf.midX - 23, y: kf.minY - 58, width: 46, height: 54)
        view.addSubview(l)
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(hidePopup),
                                               object: nil)
        perform(#selector(hidePopup), with: nil, afterDelay: 0.3)
    }

    @objc private func hidePopup() {
        popupLabel?.removeFromSuperview()
    }

    @objc private func spaceTapped() {
        completeWord()   // the word before this space is complete
        let now = Date()
        let before = textDocumentProxy.documentContextBeforeInput ?? ""
        // Double space → ". " (Brian, V1.6): two quick spaces after a word
        // become period + space, and auto-shift capitalises the next word.
        // (The learn call above is a no-op in this branch: the context
        // ends with the first space, so there is no current word.)
        if let last = lastSpaceAt, now.timeIntervalSince(last) < 0.4,
           before.hasSuffix(" "), let prev = before.dropLast().last,
           prev.isLetter || prev.isNumber {
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(". ")
            lastSpaceAt = nil
            autoShiftIfNeeded()
            updateSuggestions()
            return
        }
        textDocumentProxy.insertText(" ")
        lastSpaceAt = now
        autoShiftIfNeeded()
        updateSuggestions()
    }

    @objc private func returnTapped() {
        completeWord()
        textDocumentProxy.insertText("\n")
        updateSuggestions()
    }

    @objc private func deleteTapped() {
        textDocumentProxy.deleteBackward()
        updateSuggestions()
    }

    private func addDeleteHold(to button: KeyButton) {
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(deleteLongPressed(_:)))
        lp.minimumPressDuration = 0.4
        button.addGestureRecognizer(lp)
    }

    @objc private func deleteLongPressed(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            deleteTimer?.invalidate()
            deleteTimer = Timer.scheduledTimer(withTimeInterval: 0.065, repeats: true) { [weak self] _ in
                self?.textDocumentProxy.deleteBackward()
                self?.updateSuggestions()
            }
        case .ended, .cancelled, .failed:
            deleteTimer?.invalidate()
            deleteTimer = nil
        default:
            break
        }
    }

    @objc private func shiftTapped(_ sender: KeyButton) {
        let now = Date()
        if let last = lastShiftTap, now.timeIntervalSince(last) < 0.35, shift == .once {
            shift = .locked          // double-tap while shifted = caps lock
        } else {
            switch shift {
            case .off: shift = .once
            case .once: shift = .off
            case .locked: shift = .off
            }
        }
        lastShiftTap = now
        applyShiftVisuals()
    }

    @objc private func showNumbers() { mode = .numbers; buildKeyboard() }
    @objc private func showSymbols() { mode = .symbols; buildKeyboard() }
    @objc private func showLetters() { mode = .letters; buildKeyboard() }

    // MARK: - Auto-shift (never autocorrect — capitals only)

    private func autoShiftIfNeeded() {
        guard mode == .letters, shift == .off else { return }
        let context = textDocumentProxy.documentContextBeforeInput ?? ""
        if context.isEmpty || context.hasSuffix(". ") || context.hasSuffix("! ") || context.hasSuffix("? ") || context.hasSuffix("\n") {
            shift = .once
            applyShiftVisuals()
        }
    }
}
