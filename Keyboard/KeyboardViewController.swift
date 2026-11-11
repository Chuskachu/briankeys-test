import UIKit

/// BrianKeys V1 — the first REAL layout (design phase, step 1: completeness).
///
/// Design rules, from Brian's pain-point map:
/// - Big, clearly separated keys (54pt rows) for wide thumb contact patches.
/// - Spanish QWERTY; Ñ lives on long-press N (Brian's call — no Ñ key).
///   Accents and digits also live on long-press (a big variants strip
///   appears at the top — no tiny floating popups).
/// - Haptic feedback on every key, with space feeling deliberately
///   different — feeling the keys is the whole point of this project.
/// - Return key is buffered: extra gap before it + its own colour, because
///   Brian kept hitting it when aiming for space or delete.
/// - NO autocorrect, ever. The keyboard inserts exactly what he taps.
/// - Shift: tap = one capital, double-tap = caps lock, auto-on after ". ".

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

    // V1.6 slide-commit ("el arrastre escribe"). Brian's own diagnosis: at
    // speed he drags his finger across keys without lifting, and every key
    // after the first was silently lost. Now, when a touch drags well INTO
    // another typing key, that key commits too — once per key per touch.
    // Function keys (shift, delete, return, mode) are never slide targets:
    // a glide must not delete or submit by accident.
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

    // Haptics — Brian's insight: this is our road to "feeling" the keys,
    // the software echo of the BlackBerry's physical edges.
    // V1.3: fire on touch DOWN (instant), and make each key family feel
    // clearly different — V1.2's light/medium felt "the same everywhere".
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
    /// All keys a finger may slide-commit into on the current page (V1.6).
    private var slideKeys: [KeyButton] = []
    /// When the last single space was typed, for double-space → ". " (V1.6).
    private var lastSpaceAt: Date?
    private var popupLabel: UILabel?

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
                                        multiplier: 1.0, constant: 264)
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

        buildKeyboard()
    }

    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        autoShiftIfNeeded()
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
        KeyButton.slideTargets = slideKeys
    }

    // Key colours with real separation in dark mode too (V1.2's keys
    // blended into the background and "felt cramped" partly for that).
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
    // Pressed-state colours (V1.6): keys visibly react the instant they are
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
        // V1.5: letters register on touch DOWN, not touch-up. V1.4 test data
        // showed the #1 error class was DROPPED letters (n, e, m, p, and l
        // four times): at Brian's speed the thumb lands, slides a hair, and
        // lifts outside the key, so touchUpInside never fired. Fast
        // keyboards commit on contact.
        b.addTarget(self, action: #selector(letterTouchedDown(_:)), for: .touchDown)
        b.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        // V1.6: this key can also be typed by dragging into it.
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
        switch sender.haptic {
        case .lightKey: hapticLight.impactOccurred(intensity: 0.6)
        case .heavySpace: hapticHeavy.impactOccurred(intensity: 1.0)
        case .rigidDelete: hapticRigid.impactOccurred(intensity: 0.9)
        case .mediumReturn: hapticMedium.impactOccurred(intensity: 1.0)
        case .select: hapticSelect.selectionChanged()
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
            if ch == "l" { k.hitExpand = 6 }
            row2.append(k); letterButtons.append(k)
        }
        mainStack.addArrangedSubview(makeRow(row2))

        // Row 3: SHIFT | z x c v b n m | DELETE
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
        // V1.5 (Brian's call): EVERY key in the row the same size — shift and
        // delete become ordinary cells in a uniform grid, BlackBerry-style.
        // This also kills the last .fill row, where Z silently ate the slack
        // width and "looked weird" next to its neighbours.
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

        // NO globe key (V1.3, Brian: "ese logo del mundo molesta"). It sat in
        // his left thumb's travel path and an accidental tap teleported him
        // to Apple's keyboard mid-word — a hidden cause of "no responde
        // bien". iOS draws its own globe in the chin below the keyboard,
        // so switching keyboards still works when HE wants it.
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
        space.addTarget(self, action: #selector(spaceTapped), for: .touchDown)   // V1.5: commit on contact, like the letters
        space.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        // V1.6: dragging into space also types a space.
        space.slideEnabled = true
        space.onSlideCommit = { [weak self] target in self?.slideCommit(target) }
        slideKeys.append(space)
        row.addArrangedSubview(space)

        let period = punctKey(".")
        period.variants = [",", "?", "!", "¿", "¡", "…"]
        addLongPress(to: period)
        period.widthAnchor.constraint(equalToConstant: 36).isActive = true
        row.addArrangedSubview(period)

        // The buffer: a deliberate dead gap before Return (Brian's danger zone).
        let gap = UIView()
        gap.widthAnchor.constraint(equalToConstant: 10).isActive = true
        row.addArrangedSubview(gap)

        let ret = KeyButton(type: .system)
        ret.setTitle("⏎", for: .normal)
        ret.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        ret.setTitleColor(.label, for: .normal)
        paint(ret, normal: UIColor.systemTeal.withAlphaComponent(0.35),
              pressed: UIColor.systemTeal.withAlphaComponent(0.6))
        ret.layer.cornerRadius = 10
        ret.haptic = .mediumReturn
        ret.widthAnchor.constraint(equalToConstant: 44).isActive = true   // V1.6: a touch narrower, space grows again
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
        heightConstraint.constant = 318
    }

    @objc private func hideVariants() {
        variantStrip.isHidden = true
        heightConstraint.constant = 264
    }

    @objc private func variantTapped(_ sender: UIButton) {
        guard let s = sender.title(for: .normal) else { return }
        hapticLight.impactOccurred()
        // The base character was already inserted on touch-down (V1.5);
        // choosing a variant REPLACES it instead of adding a second char.
        if pendingVariantKey != nil {
            textDocumentProxy.deleteBackward()
            pendingVariantKey = nil
        }
        insertTextSmart(s)
        hideVariants()
    }

    // MARK: - Actions

    private func insertTextSmart(_ text: String) {
        lastSpaceAt = nil   // any real character breaks a double-space chain
        var out = text
        if text.count == 1, text.first!.isLetter {
            out = (shift == .off) ? text.lowercased() : text.uppercased()
        }
        textDocumentProxy.insertText(out)
        if shift == .once, text.count == 1, text.first!.isLetter {
            shift = .off
            applyShiftVisuals()   // V1.3: update in place — never rebuild mid-typing
        }
    }

    /// Shift visuals WITHOUT rebuilding the keyboard. V1.2 rebuilt the whole
    /// view on every shift change and auto-shift check, and those rebuilds
    /// swallowed touches while Brian typed fast ("no responde bien").
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

    /// V1.6: a drag entered this key mid-touch — type it as if tapped.
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

    /// The classic key popup: the letter, enlarged, floating above the key.
    /// Visual proof the key registered — feedback Brian's eyes can trust.
    private func showPopup(for key: KeyButton) {
        guard let text = key.title(for: .normal) ?? key.accessibilityLabel,
              !text.isEmpty, text.count <= 2, key.window != nil else { return }
        popupLabel?.removeFromSuperview()
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 30, weight: .medium)
        l.textAlignment = .center
        l.backgroundColor = keyPressedColor
        l.layer.cornerRadius = 8
        l.layer.borderWidth = 0.5
        l.layer.borderColor = UIColor.separator.cgColor
        l.layer.masksToBounds = true
        let kf = key.convert(key.bounds, to: view)
        l.frame = CGRect(x: kf.midX - 23, y: kf.minY - 58, width: 46, height: 54)
        view.addSubview(l)
        popupLabel = l
        UIView.animate(withDuration: 0.22, delay: 0.18, options: []) {
            l.alpha = 0
        } completion: { _ in
            if self.popupLabel == l { self.popupLabel = nil }
            l.removeFromSuperview()
        }
    }

    @objc private func spaceTapped() {
        let now = Date()
        let before = textDocumentProxy.documentContextBeforeInput ?? ""
        // V1.6 (Brian): double space → ". " — two quick spaces after a word
        // become period + space, and auto-shift capitalises the next word.
        if let last = lastSpaceAt, now.timeIntervalSince(last) < 0.4,
           before.hasSuffix(" "), let prev = before.dropLast().last,
           prev.isLetter || prev.isNumber {
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(". ")
            lastSpaceAt = nil
            autoShiftIfNeeded()
            return
        }
        textDocumentProxy.insertText(" ")
        lastSpaceAt = now
        autoShiftIfNeeded()
    }

    @objc private func returnTapped() {
        textDocumentProxy.insertText("\n")
    }

    @objc private func deleteTapped() {
        textDocumentProxy.deleteBackward()
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
