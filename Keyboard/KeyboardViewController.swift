import UIKit

/// BrianKeys — Brian's own keyboard, built with him, for his thumbs.
///
/// Design rules, from Brian's pain-point map:
/// - Big, clearly separated keys for wide thumb contact patches.
/// - Spanish QWERTY; Ñ lives on long-press N (Brian's call — no Ñ key).
///   Accents and digits also live on long-press (a big variants strip
///   appears at the top — no tiny floating popups).
/// - Haptics were our road to "feeling" the keys (Brian's insight), but
///   v0.2 REMOVES them from every key except the space bar (Brian's
///   call): a pulse lands AFTER the touch, and at his speed the brain
///   reads that delay as a slow keyboard. Space keeps its heavy DOUBLE
///   pulse — the one key he always felt, and the one that matters.
/// - Version scheme (Brian, 2026-11-12): v0.2, v0.3, v0.4… —
///   "para números enteros no estamos".
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
    /// v0.2: window frames cached at layout time (see touchesMoved).
    static var frameCache: [ObjectIdentifier: CGRect] = [:]
    var slideEnabled = false
    var onSlideCommit: ((KeyButton, CGPoint) -> Void)?
    private var slidCommitted: Set<ObjectIdentifier> = []

    // v0.5 (Brian): flick DOWN on the space bar = Enter (the Return key
    // is gone; the bar runs to the right edge where his thumb lands).
    // The VC converts the already-committed space into a newline.
    var onFlickDown: (() -> Void)?
    private var touchStartY: CGFloat?
    private var flickFired = false

    /// V1.9 touch logger hook: every physical touch-down on any key is
    /// reported (with its window point) before any action fires — the
    /// raw material for measuring where Brian's thumb actually lands.
    static var onAnyTouchDown: ((KeyButton, CGPoint) -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        slidCommitted = [ObjectIdentifier(self)]
        flickFired = false
        if let t = touches.first {
            touchStartY = t.location(in: nil).y
            KeyButton.onAnyTouchDown?(self, t.location(in: nil))
        }
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        // v0.5 flick check first: it must work even where slide is off
        // (the emoji page's space bar has no slide machinery).
        if isSpaceKey, !flickFired, let startY = touchStartY, let t = touches.first,
           t.location(in: nil).y - startY >= 24 {
            flickFired = true
            onFlickDown?()
        }
        guard slideEnabled, let touch = touches.first, let handler = onSlideCommit else { return }
        let p = touch.location(in: nil)   // window coordinates
        for target in KeyButton.slideTargets {
            let id = ObjectIdentifier(target)
            if slidCommitted.contains(id) { continue }
            // Must be well inside the target, not just grazing its edge.
            // v0.2: frame from the layout cache, not a fresh conversion
            // of every target on every move event.
            let f = (KeyButton.frameCache[id] ?? target.convert(target.bounds, to: nil)).insetBy(dx: 6, dy: 5)
            if f.contains(p) {
                slidCommitted.insert(id)
                handler(target, p)
            }
        }
    }
}

class KeyboardViewController: UIInputViewController {

    private enum Mode { case letters, numbers, symbols, emoji }
    private enum Shift { case off, once, locked }

    private var mode: Mode = .letters
    private var shift: Shift = .once

    private var mainStack: UIStackView!
    private var variantStrip: UIStackView!
    /// Second strip, only used by the log panel (v0.2 speed toggles).
    private var panelStrip: UIStackView!
    private var deleteTimer: Timer?
    private var heightConstraint: NSLayoutConstraint!
    private var lastShiftTap: Date?

    // Haptics — v0.2: ONLY the space bar has one (heavy double pulse).
    // Every other generator is gone (Brian: the pulse arrives after the
    // touch and the brain reads that delay as a slow keyboard).
    private let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private var letterButtons: [KeyButton] = []
    private var shiftButton: KeyButton?
    /// The key whose character was just inserted on touch-down, so a
    /// long-press variant can replace it (delete + insert variant).
    private weak var pendingVariantKey: KeyButton?
    /// v0.4: the exact character the pending key inserted. variantTapped
    /// deletes ONLY if the document's last char still equals it — the
    /// defensive fix for the "á eats the previous letter" bug.
    private var pendingBaseChar: String? = nil
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

    /// v0.2 speed diet: the current word, tracked LOCALLY from our own
    /// inserts and deletes. Reading textDocumentProxy on every keystroke
    /// is a round-trip to the host app; the mirror takes it off the
    /// letter path. textDidChange resyncs it when a change comes from
    /// outside (field switch, cursor move, host-app edits).
    private var localWord: String = ""

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
    /// Accent-folded forms of the learned words, cached (v0.2 diet).
    private var learnedFolded: [String: String] = [:]

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
        hapticHeavy.prepare()
        // Seed the folded-form cache for learned words (v0.2 diet:
        // computeSuggestions used to re-fold every learned word on
        // every single keystroke).
        learnedFolded = Dictionary(uniqueKeysWithValues: learned.keys.map { ($0, fold($0)) })

        // V1.9 touch logger: observe every key's physical touch-down.
        KeyButton.onAnyTouchDown = { [weak self] key, wpt in
            self?.touchDownObserved(key, windowPoint: wpt)
        }

        heightConstraint = NSLayoutConstraint(item: view!, attribute: .height,
                                        relatedBy: .equal, toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: 315)
        heightConstraint.priority = UILayoutPriority(999)
        view.addConstraint(heightConstraint)

        mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.distribution = .fill
        mainStack.spacing = 0   // v0.4: ZERO gaps between key rows (Brian's idea)
        // The tray shows through the rounded corners of the touching keys.
        view.backgroundColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1)
                : UIColor(red: 0.82, green: 0.83, blue: 0.86, alpha: 1)
        }
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
        // If the proxy's word disagrees with our mirror, the change came
        // from outside: adopt it and refresh the bar. When they agree,
        // our own action handler already updated it — this is what keeps
        // suggestions at ONE compute per keystroke (v0.2 diet).
        let proxyWord = currentWord()
        if proxyWord != localWord {
            localWord = proxyWord
            updateSuggestions()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flushLog()   // v0.2: don't strand buffered log events
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // v0.2: cache the slide/rescue key frames at layout time instead
        // of converting ~30 frames on every touchesMoved event.
        for key in slideKeys where key.window != nil {
            KeyButton.frameCache[ObjectIdentifier(key)] = key.convert(key.bounds, to: nil)
        }
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
        pendingVariantKey = nil
        pendingBaseChar = nil
        // v0.4 (Brian): coming back to the letters after "? ", "! " or
        // ". " must start capitalised. autoShiftIfNeeded only fires in
        // letters mode, and the keys built below read `shift` for their
        // titles, so checking here covers the ABC-return path that
        // spaceTapped's own check missed (mode was still .symbols then).
        autoShiftIfNeeded()

        mainStack.addArrangedSubview(suggestionBar)

        // Variants strip (hidden until a long-press).
        variantStrip = UIStackView()
        variantStrip.axis = .horizontal
        variantStrip.distribution = .fillEqually
        variantStrip.spacing = 5
        variantStrip.isHidden = true
        variantStrip.heightAnchor.constraint(equalToConstant: 46).isActive = true
        mainStack.addArrangedSubview(variantStrip)

        // Second strip (hidden unless the log panel is open, v0.2).
        panelStrip = UIStackView()
        panelStrip.axis = .horizontal
        panelStrip.distribution = .fillEqually
        panelStrip.spacing = 5
        panelStrip.isHidden = true
        panelStrip.heightAnchor.constraint(equalToConstant: 46).isActive = true
        mainStack.addArrangedSubview(panelStrip)

        switch mode {
        case .letters: buildLetters()
        case .numbers: buildNumbers()
        case .symbols: buildSymbols()
        case .emoji: buildEmoji()
        }
        // V1.8: space is NOT a slide target anymore. V1.7 data showed a
        // space sneaking in before commas and question marks — his drag
        // toward the punctuation clipped the space bar on the way past.
        // Space still commits on direct touch (and via proximity rescue,
        // which reads slideKeys, not slideTargets).
        KeyButton.slideTargets = slideKeys.filter { !$0.isSpaceKey }
        updateSuggestions()
    }

    // v0.3: iPhone-style palette (Brian asked for Apple's look): white
    // keycaps in light mode, mid-grey in dark mode, grey function keys.
    private var keyColor: UIColor {
        UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.36, green: 0.36, blue: 0.38, alpha: 1)
            : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1) }
    }
    private var functionKeyColor: UIColor {
        UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.20, green: 0.20, blue: 0.22, alpha: 1)
            : UIColor(red: 0.66, green: 0.68, blue: 0.72, alpha: 1) }
    }
    // Pressed-state colours: keys visibly react the instant they are
    // touched — part of "responde lento" was that nothing SEEMED to happen.
    private var keyPressedColor: UIColor {
        UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.52, green: 0.52, blue: 0.55, alpha: 1)
            : UIColor(red: 0.84, green: 0.85, blue: 0.87, alpha: 1) }
    }
    private var functionPressedColor: UIColor {
        UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.30, green: 0.30, blue: 0.32, alpha: 1)
            : UIColor(red: 0.52, green: 0.54, blue: 0.58, alpha: 1) }
    }

    private func solidImage(_ color: UIColor) -> UIImage {
        // v0.3: bake the 1x1 image with the KEYBOARD's own trait
        // collection. The default renderer uses the main screen's traits;
        // when the host app asks the keyboard for the other appearance,
        // the frozen image kept the wrong mode's colour while the labels
        // followed the view — Brian's "se invierte el color" (2026-11-12).
        let resolved = color.resolvedColor(with: traitCollection)
        return UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { ctx in
            resolved.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

    // v0.3: if the appearance flips while the keyboard is up, repaint
    // everything in the new mode instead of keeping frozen images.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle,
           mainStack != nil {
            buildKeyboard()
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
        row.spacing = 0   // v0.4: keys touch — no dead gap to fall into
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
        b.layer.cornerRadius = 12
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
        b.onSlideCommit = { [weak self] target, pt in self?.slideCommit(target, windowPoint: pt, via: "slide") }
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
        b.layer.cornerRadius = 12
        b.haptic = .select
        b.addTarget(self, action: action, for: .touchUpInside)
        b.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        b.setContentHuggingPriority(.defaultLow, for: .horizontal)
        // V1.9: long-press on a page key (123 / ABC / #+=) opens the
        // touch-log panel — recording toggle, copy, erase.
        if ["123", "ABC", "#+="].contains(title) {
            let lp = UILongPressGestureRecognizer(target: self, action: #selector(logPanelPressed(_:)))
            lp.minimumPressDuration = 0.4
            b.addGestureRecognizer(lp)
        }
        return b
    }

    @objc private func keyTouchedDown(_ sender: KeyButton) {
        // v0.2: haptics ONLY on the space bar — a heavy double pulse.
        // All other keys are silent: at Brian's speed the pulse lands
        // after the letter and reads as lag, not as feel.
        guard sender.haptic == .heavySpace else { return }
        hapticHeavy.impactOccurred(intensity: 0.85)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) { [weak self] in
            self?.hapticHeavy.impactOccurred(intensity: 0.55)
            self?.hapticHeavy.prepare()
        }
        hapticHeavy.prepare()
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
            // v0.4: no hitExpand anywhere — with zero gaps the frames tile
            // exactly; an expansion would steal from the neighbour.
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

    // v0.5 (Brian): our own emoji page — his pick over jumping to the
    // system emoji keyboard. ☺ on the letters page opens it; tapping an
    // emoji inserts it and the page STAYS open (several in a row is
    // normal); ABC comes back to the letters.
    private func buildEmoji() {
        let rows: [[String]] = [
            ["😂", "🤣", "😄", "😅", "😊", "🥰", "😍", "😘"],
            ["😉", "😎", "🤔", "🤨", "😴", "🥱", "😢", "😭"],
            ["😱", "🤯", "🥳", "👍", "👎", "🙏", "👏", "💪"],
            ["❤️", "🔥", "🎉", "✨", "⭐", "🎮", "☕", "🍺"]
        ]
        for emojis in rows {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = 0   // zero-gap tiling, like the letter keys
            row.heightAnchor.constraint(equalToConstant: 56).isActive = true
            for e in emojis {
                let b = UIButton(type: .system)
                b.setTitle(e, for: .normal)
                b.titleLabel?.font = .systemFont(ofSize: 26)
                b.backgroundColor = keyColor
                b.layer.cornerRadius = 12
                b.addTarget(self, action: #selector(emojiTouchDown(_:)), for: .touchDown)
                b.addTarget(self, action: #selector(emojiTouchUp(_:)), for: [.touchUpOutside, .touchCancel])
                b.addTarget(self, action: #selector(emojiTapped(_:)), for: .touchUpInside)
                row.addArrangedSubview(b)
            }
            mainStack.addArrangedSubview(row)
        }
        // Bottom row: ABC back, a space, and delete (hold repeats).
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = 0
        row.heightAnchor.constraint(equalToConstant: 56).isActive = true
        let abc = functionKey("ABC", action: #selector(showLetters))
        abc.widthAnchor.constraint(equalToConstant: 64).isActive = true
        row.addArrangedSubview(abc)
        let space = KeyButton(type: .system)
        space.setTitle("space", for: .normal)
        space.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        space.setTitleColor(.label, for: .normal)
        paint(space, normal: keyColor, pressed: keyPressedColor)
        space.layer.cornerRadius = 12
        space.isSpaceKey = true   // v0.5: the flick works on this bar too
        space.onFlickDown = { [weak self] in self?.spaceFlickedToEnter() }
        space.addTarget(self, action: #selector(spaceTapped), for: .touchDown)
        row.addArrangedSubview(space)
        let del = functionKey("⌫", action: #selector(deleteTapped))
        del.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addDeleteHold(to: del)
        row.addArrangedSubview(del)
        mainStack.addArrangedSubview(row)
    }

    @objc private func emojiTouchDown(_ sender: UIButton) {
        sender.backgroundColor = keyPressedColor
    }

    @objc private func emojiTouchUp(_ sender: UIButton) {
        sender.backgroundColor = keyColor
    }

    @objc private func emojiTapped(_ sender: UIButton) {
        sender.backgroundColor = keyColor
        guard let e = sender.title(for: .normal) else { return }
        completeWord()          // the word before the emoji is finished
        localWord = ""
        pendingVariantKey = nil; pendingBaseChar = nil
        textDocumentProxy.insertText(e)
        updateSuggestions()
        // Stay on the emoji page: Brian may want two or three in a row.
    }

    private func bottomRow(modeTitle: String, modeAction: Selector) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = 0   // v0.4 zero-gap tiling applies to this row too
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

        if mode == .letters {
            // v0.5 (Brian): the smiley button he missed — opens our own
            // emoji page. Its width comes out of the space bar.
            let emojiBtn = functionKey("☺", action: #selector(showEmoji))
            emojiBtn.titleLabel?.font = .systemFont(ofSize: 20)
            emojiBtn.widthAnchor.constraint(equalToConstant: 34).isActive = true
            row.addArrangedSubview(emojiBtn)
        }

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
        space.layer.cornerRadius = 12
        space.haptic = .heavySpace
        space.isSpaceKey = true
        // v0.4: space no longer steals edge points — zero-gap tiling.
        space.addTarget(self, action: #selector(spaceTapped), for: .touchDown)   // commit on contact, like the letters
        space.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        // V1.8: long-press space = the prudent corrector's ON/OFF switch.
        let spaceLP = UILongPressGestureRecognizer(target: self, action: #selector(spaceLongPressed(_:)))
        spaceLP.minimumPressDuration = 0.4
        space.addGestureRecognizer(spaceLP)
        space.accessibilityLabel = "SPACE"
        // Dragging into space also types a space (V1.6).
        space.slideEnabled = true
        space.onSlideCommit = { [weak self] target, pt in self?.slideCommit(target, windowPoint: pt, via: "slide") }
        slideKeys.append(space)
        // v0.5 (Brian): flick down on the bar = Enter.
        space.onFlickDown = { [weak self] in self?.spaceFlickedToEnter() }
        row.addArrangedSubview(space)

        // v0.5 (Brian): THE RETURN KEY IS GONE. It was his danger zone
        // from day one (hit by accident when aiming for space or
        // delete); now the space bar runs to the right edge — where his
        // thumb lands anyway — and Enter lives in the downward flick on
        // the bar (see spaceFlickedToEnter). Flick only, no long-press
        // Enter: the long-press keeps its corrector-toggle job.

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
        panelStrip.isHidden = true
        variantStrip.isHidden = false
        heightConstraint.constant = 368
    }

    @objc private func hideVariants() {
        variantStrip.isHidden = true
        panelStrip?.isHidden = true
        heightConstraint.constant = 315
    }

    @objc private func variantTapped(_ sender: UIButton) {
        guard let s = sender.title(for: .normal) else { return }
        // The base character was already inserted on touch-down (V1.5);
        // choosing a variant REPLACES it instead of adding a second char.
        // v0.4 defensive fix (Brian's bug: "á" also deleted the letter
        // BEFORE the a): delete only when the document's real last
        // character is exactly the base char this key inserted;
        // otherwise insert without deleting. Every outcome is logged
        // (VAR) so a recurrence is measurable instead of mysterious.
        var deleted = false
        if pendingVariantKey != nil, let base = pendingBaseChar {
            let context = textDocumentProxy.documentContextBeforeInput ?? ""
            if let last = context.last, String(last) == base {
                textDocumentProxy.deleteBackward()
                if !localWord.isEmpty { localWord.removeLast() }
                deleted = true
            }
        }
        if logEnabled {
            logEvent(k: "VAR:" + s, m: deleted ? "var-fix" : "var-keep",
                     viewPoint: .zero, frame: nil)
        }
        pendingVariantKey = nil
        pendingBaseChar = nil
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
        learnedFolded[w] = fold(w)
        if learned.count > 800 {   // keep the store lean: top 400 survive
            learned = Dictionary(uniqueKeysWithValues:
                learned.sorted { $0.value > $1.value }.prefix(400).map { ($0.key, $0.value) })
            learnedFolded = Dictionary(uniqueKeysWithValues: learned.keys.map { ($0, fold($0)) })
        }
        UserDefaults.standard.set(learned, forKey: learnedKey)
    }

    /// A word was just completed (space / punctuation / return): first
    /// let the prudent corrector judge it, then learn the FINAL form —
    /// a corrected word reinforces its correction, and the raw typo is
    /// never learned.
    private func completeWord() {
        let w = localWord
        guard w.count >= 2 else { return }
        var final = w
        if prudentEnabled, let fixed = prudentFix(for: w) {
            replaceCurrentWord(with: fixed)
            final = fixed
            // (v0.2: the corrector's old double-tick haptic is gone —
            // haptics are space-only now. The corrector is parked anyway.)
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
        for _ in localWord { textDocumentProxy.deleteBackward() }
        textDocumentProxy.insertText(fixed)
        localWord = fixed
    }

    /// Long-press on space: the prudent corrector's switch + a flash in
    /// the bar so he SEES the state change.
    @objc private func spaceLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        prudentEnabled.toggle()
        UserDefaults.standard.set(prudentEnabled, forKey: prudentKey)
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
            .filter { (learnedFolded[$0.key] ?? fold($0.key)).hasPrefix(fp) }
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
        guard suggEnabled else {
            currentSuggestions = []
            for chip in chips {
                chip.setTitle("", for: .normal)
                chip.isEnabled = false
                chip.alpha = 0.35
            }
            return
        }
        currentSuggestions = computeSuggestions(for: localWord)
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
        for _ in localWord { textDocumentProxy.deleteBackward() }
        localWord = ""
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

    // MARK: - Touch logger (V1.9 — Brian's idea, 2026-11-12)
    //
    // Five versions of guessing his thumb drift were enough: MEASURE it.
    // When recording is ON (his switch, default OFF), every commit is
    // logged as one JSON line: epoch-ms, key, method (tap / slide /
    // rescue / rslide / down-fn / miss), the touch point and the key's
    // frame, in keyboard-view points. The log lives in the extension's
    // own container (the app cannot read it — App Groups wall), so it
    // leaves the phone only when Brian taps "Copiar log" in the panel
    // (long-press 123) and pastes it to Muse himself. Capped at ~5,000
    // events. His SwiftKey warning stands: this is a measuring
    // instrument, not an invisible auto-tuner — any hit-zone warping
    // must first prove itself in the suite data.

    private let logOnKey = "bk_log_on_v1"
    private lazy var logEnabled: Bool = UserDefaults.standard.bool(forKey: logOnKey)
    // v0.2 Speed Lab toggles (log panel, strip 2). Both default ON;
    // Brian flips them to isolate what each feature costs at speed.
    private let popupKey = "bk_popup_v1"
    private let suggKey = "bk_sugg_v1"
    private lazy var popupEnabled: Bool = UserDefaults.standard.object(forKey: popupKey) as? Bool ?? true
    private lazy var suggEnabled: Bool = UserDefaults.standard.object(forKey: suggKey) as? Bool ?? true
    private var logHandle: FileHandle?
    private var logOpened = false
    private var logCount = 0

    private var logURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("bk_touchlog.jsonl")
    }

    private func keyLabel(_ key: KeyButton) -> String {
        key.accessibilityLabel ?? key.title(for: .normal) ?? "?"
    }

    private func touchDownObserved(_ key: KeyButton, windowPoint: CGPoint) {
        guard logEnabled else { return }
        let isTyping = slideKeys.contains { $0 === key }
        logEvent(k: keyLabel(key), m: isTyping ? "tap" : "down-fn",
                 viewPoint: view.convert(windowPoint, from: nil),
                 frame: key.convert(key.bounds, to: view))
    }

    private func logEvent(k: String, m: String, viewPoint: CGPoint, frame: CGRect?) {
        let t = Int(Date().timeIntervalSince1970 * 1000)
        let safeK = k.replacingOccurrences(of: "\\", with: "\\\\")
                     .replacingOccurrences(of: "\"", with: "\\\"")
        var line = "{\"t\":\(t),\"k\":\"\(safeK)\",\"m\":\"\(m)\",\"x\":\(Int(viewPoint.x.rounded())),\"y\":\(Int(viewPoint.y.rounded()))"
        if let f = frame {
            line += ",\"f\":[\(Int(f.origin.x.rounded())),\(Int(f.origin.y.rounded())),\(Int(f.size.width.rounded())),\(Int(f.size.height.rounded()))]"
        }
        line += "}\n"
        appendLogLine(line)
    }

    /// v0.2: events buffer in MEMORY and flush in batches of 40 — the
    /// old code wrote every single touch to disk synchronously, on the
    /// main thread, while recording (i.e. during every measured test).
    private var logBuffer: [String] = []

    private func ensureLogCount() {
        if !logOpened {
            logOpened = true
            if !FileManager.default.fileExists(atPath: logURL.path) {
                FileManager.default.createFile(atPath: logURL.path, contents: nil)
                logCount = 0
            } else if let data = try? Data(contentsOf: logURL) {
                logCount = data.reduce(0) { $0 + ($1 == 10 ? 1 : 0) }
            }
        }
    }

    private func appendLogLine(_ line: String) {
        ensureLogCount()
        logBuffer.append(line)
        logCount += 1
        if logBuffer.count >= 40 { flushLog() }
        if logCount > 5000 { trimLog() }
    }

    private func flushLog() {
        guard !logBuffer.isEmpty else { return }
        if logHandle == nil {
            logHandle = try? FileHandle(forWritingTo: logURL)
            _ = try? logHandle?.seekToEnd()
        }
        if let h = logHandle, let d = logBuffer.joined().data(using: .utf8) { h.write(d) }
        logBuffer.removeAll()
    }

    /// Keep the newest 4,000 events when the cap is crossed.
    private func trimLog() {
        flushLog()
        try? logHandle?.close()
        logHandle = nil
        if let text = try? String(contentsOf: logURL, encoding: .utf8) {
            let lines = text.split(separator: "\n", omittingEmptySubsequences: true).suffix(4000)
            try? lines.joined(separator: "\n").appending("\n").write(to: logURL, atomically: true, encoding: .utf8)
            logCount = lines.count
        }
        logHandle = try? FileHandle(forWritingTo: logURL)
        _ = try? logHandle?.seekToEnd()
    }

    // MARK: Log panel (long-press 123)

    /// Set when the log panel opens: the mode key's own touchUpInside
    /// fires when the long-press is released, and it must NOT switch
    /// pages and tear the panel down. Consumed once by the mode actions.
    private var logPanelJustOpened = false

    @objc private func logPanelPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        logPanelJustOpened = true
        showLogPanel()
    }

    private func stripButton(_ title: String, _ action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        b.titleLabel?.adjustsFontSizeToFitWidth = true   // v0.4: no more "…do: SÍ"
        b.titleLabel?.minimumScaleFactor = 0.6
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .systemOrange.withAlphaComponent(0.30)
        b.layer.cornerRadius = 8
        b.addTarget(self, action: action, for: .touchUpInside)
        return b
    }

    private func showLogPanel() {
        ensureLogCount()
        for arranged in variantStrip.arrangedSubviews {
            variantStrip.removeArrangedSubview(arranged)
            arranged.removeFromSuperview()
        }
        variantStrip.addArrangedSubview(stripButton(
            logEnabled ? "⏺ Grabando SÍ" : "⏺ Grabar NO", #selector(logToggleTapped)))
        variantStrip.addArrangedSubview(stripButton("📋 Copiar (\(logCount))", #selector(logCopyTapped)))
        variantStrip.addArrangedSubview(stripButton("🗑 Borrar", #selector(logClearTapped)))
        let close = UIButton(type: .system)
        close.setTitle("✕", for: .normal)
        close.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        close.setTitleColor(.label, for: .normal)
        close.backgroundColor = .tertiarySystemBackground
        close.layer.cornerRadius = 8
        close.addTarget(self, action: #selector(hideVariants), for: .touchUpInside)
        variantStrip.addArrangedSubview(close)

        // Strip 2 (v0.2 Speed Lab): popup + suggestions toggles and the
        // version tag. Toggling writes a CFG marker into the log (when
        // recording) so one suite run stays segmented by configuration.
        for arranged in panelStrip.arrangedSubviews {
            panelStrip.removeArrangedSubview(arranged)
            arranged.removeFromSuperview()
        }
        panelStrip.addArrangedSubview(stripButton(
            popupEnabled ? "👁 Popup: SÍ" : "👁 Popup: NO", #selector(popupToggleTapped)))
        panelStrip.addArrangedSubview(stripButton(
            suggEnabled ? "💡 Suger: SÍ" : "💡 Suger: NO", #selector(suggToggleTapped)))
        let ver = stripButton("BrianKeys v0.5 Speed Lab", #selector(popupToggleTapped))
        ver.isEnabled = false
        panelStrip.addArrangedSubview(ver)
        panelStrip.isHidden = false
        variantStrip.isHidden = false
        heightConstraint.constant = 421
    }

    @objc private func popupToggleTapped() {
        popupEnabled.toggle()
        UserDefaults.standard.set(popupEnabled, forKey: popupKey)
        if !popupEnabled { hidePopup() }
        if logEnabled { logEvent(k: "CFG", m: popupEnabled ? "popup-on" : "popup-off", viewPoint: .zero, frame: nil) }
        showLogPanel()
    }

    @objc private func suggToggleTapped() {
        suggEnabled.toggle()
        UserDefaults.standard.set(suggEnabled, forKey: suggKey)
        if logEnabled { logEvent(k: "CFG", m: suggEnabled ? "sugg-on" : "sugg-off", viewPoint: .zero, frame: nil) }
        updateSuggestions()
        showLogPanel()
    }

    @objc private func logToggleTapped() {
        logEnabled.toggle()
        UserDefaults.standard.set(logEnabled, forKey: logOnKey)
        showLogPanel()   // rebuild so the state and count are current
    }

    @objc private func logCopyTapped() {
        flushLog()
        try? logHandle?.synchronize()
        let text = (try? String(contentsOf: logURL, encoding: .utf8)) ?? ""
        hideVariants()
        if text.isEmpty {
            flashBar("Log vacío", "")
        } else {
            UIPasteboard.general.string = text
            flashBar("✓ Log copiado", "\(logCount) toques")
        }
    }

    @objc private func logClearTapped() {
        try? logHandle?.close()
        logHandle = nil
        logOpened = false
        logBuffer.removeAll()
        logCount = 0
        try? "".write(to: logURL, atomically: true, encoding: .utf8)
        hideVariants()
        flashBar("🗑 Log borrado", "")
    }

    /// Show a two-part message in the suggestion bar for ~1.4s.
    private func flashBar(_ a: String, _ b: String) {
        chips[0].setTitle(a, for: .normal)
        chips[1].setTitle(b, for: .normal)
        chips[2].setTitle("", for: .normal)
        for c in chips { c.isEnabled = false; c.alpha = 1 }
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(refreshBar),
                                               object: nil)
        perform(#selector(refreshBar), with: nil, afterDelay: 1.4)
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
            guard let key = nearestTypingKey(to: p, strict: false) else {
                // A gap touch no typing key claimed: log the miss (only
                // below the suggestion bar — brushes on the bar are noise).
                if logEnabled, p.y > suggestionBar.convert(suggestionBar.bounds, to: nil).maxY {
                    logEvent(k: "∅", m: "miss", viewPoint: view.convert(p, from: nil), frame: nil)
                }
                continue
            }
            rescuedTouches[ObjectIdentifier(touch)] = [ObjectIdentifier(key)]
            slideCommit(key, windowPoint: p, via: "rescue")
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
            slideCommit(key, windowPoint: p, via: "rslide")
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
            let f = KeyButton.frameCache[ObjectIdentifier(key)] ?? key.convert(key.bounds, to: nil)
            if strict {
                if f.insetBy(dx: 6, dy: 5).contains(p) { return key }
            } else if f.insetBy(dx: -5, dy: -3).contains(p) {
                let d = hypot(f.midX - p.x, f.midY - p.y)
                if d < bestDist { bestDist = d; best = key }
            }
        }
        if strict || best != nil { return best }
        for key in slideKeys where key.window != nil {
            let f = KeyButton.frameCache[ObjectIdentifier(key)] ?? key.convert(key.bounds, to: nil)
            let d = hypot(f.midX - p.x, f.midY - p.y)
            if d < bestDist { bestDist = d; best = key }
        }
        return bestDist <= 36 ? best : nil
    }

    // MARK: - Actions

    private func insertTextSmart(_ text: String) {
        if text.count == 1, let c = text.first, !c.isLetter, c != " " {
            completeWord()   // a punctuation mark completes a word
            localWord = ""
        }
        lastSpaceAt = nil   // any real character breaks a double-space chain
        var out = text
        if text.count == 1, text.first!.isLetter {
            out = (shift == .off) ? text.lowercased() : text.uppercased()
        }
        textDocumentProxy.insertText(out)
        if out.count == 1, let oc = out.first, oc.isLetter { localWord.append(oc) }
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
        pendingBaseChar = localWord.last.map { String($0) }
        showPopup(for: sender)
    }

    /// A drag (or a rescued gap touch) entered this key — type it as if
    /// tapped. Only typing keys are ever passed here.
    private func slideCommit(_ target: KeyButton, windowPoint: CGPoint, via: String) {
        guard variantStrip == nil || variantStrip.isHidden else { return }
        if logEnabled {
            logEvent(k: keyLabel(target), m: via,
                     viewPoint: view.convert(windowPoint, from: nil),
                     frame: target.convert(target.bounds, to: view))
        }
        keyTouchedDown(target)   // the target family's own haptic
        if target.isSpaceKey {
            spaceTapped()
        } else if let label = target.accessibilityLabel ?? target.title(for: .normal) {
            insertTextSmart(label)
            pendingVariantKey = target
            pendingBaseChar = localWord.last.map { String($0) }
            showPopup(for: target)
        }
    }

    /// The classic key popup: the letter, enlarged, above the key — visual
    /// proof the key registered. V1.7 diet: ONE reused label, no fade
    /// animation (an animation per keystroke was pure main-thread cost).
    private func showPopup(for key: KeyButton) {
        guard popupEnabled,
              let text = key.title(for: .normal) ?? key.accessibilityLabel,
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
        pendingVariantKey = nil; pendingBaseChar = nil   // v0.4: word boundary
        completeWord()   // the word before this space is complete
        localWord = ""
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

    /// v0.5 (Brian): the downward flick on the space bar = Enter. The
    /// space was already committed on touch-down; convert it — but ONLY
    /// when the document really ends with that plain space. If the tap
    /// was the second half of a double-space, the text ends in ". " and
    /// the flick is ignored (no half-converted punctuation).
    @objc private func spaceFlickedToEnter() {
        let context = textDocumentProxy.documentContextBeforeInput ?? ""
        guard context.hasSuffix(" "), !context.hasSuffix(". ") else { return }
        textDocumentProxy.deleteBackward()
        lastSpaceAt = nil
        if logEnabled {
            logEvent(k: "SPACE", m: "flick-enter", viewPoint: .zero, frame: nil)
        }
        returnTapped()
    }

    @objc private func returnTapped() {
        pendingVariantKey = nil; pendingBaseChar = nil   // v0.4
        completeWord()
        localWord = ""
        textDocumentProxy.insertText("\n")
        updateSuggestions()
    }

    @objc private func deleteTapped() {
        pendingVariantKey = nil; pendingBaseChar = nil   // v0.4: base char may be gone
        textDocumentProxy.deleteBackward()
        if !localWord.isEmpty { localWord.removeLast() }
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
                guard let self else { return }
                self.textDocumentProxy.deleteBackward()
                if !self.localWord.isEmpty { self.localWord.removeLast() }
                self.updateSuggestions()
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

    @objc private func showNumbers() {
        if logPanelJustOpened { logPanelJustOpened = false; return }
        mode = .numbers; buildKeyboard()
    }
    @objc private func showSymbols() {
        if logPanelJustOpened { logPanelJustOpened = false; return }
        mode = .symbols; buildKeyboard()
    }
    @objc private func showLetters() {
        if logPanelJustOpened { logPanelJustOpened = false; return }
        mode = .letters; buildKeyboard()
    }
    @objc private func showEmoji() {
        if logPanelJustOpened { logPanelJustOpened = false; return }
        mode = .emoji; buildKeyboard()
    }

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
