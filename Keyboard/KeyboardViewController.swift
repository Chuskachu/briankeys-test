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
    var variants: [String] = []
    var isShiftKey = false
    var isDeleteKey = false
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
    private let hapticLight = UIImpactFeedbackGenerator(style: .light)
    private let hapticMedium = UIImpactFeedbackGenerator(style: .medium)
    private let hapticSelect = UISelectionFeedbackGenerator()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hapticLight.prepare()
        hapticMedium.prepare()
        hapticSelect.prepare()

        heightConstraint = NSLayoutConstraint(item: view!, attribute: .height,
                                        relatedBy: .equal, toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: 252)
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
    }

    private func makeRow(_ keys: [KeyButton]) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = 5
        row.heightAnchor.constraint(equalToConstant: 54).isActive = true
        for key in keys { row.addArrangedSubview(key) }
        return row
    }

    private func letterKey(_ char: String, variants: [String] = []) -> KeyButton {
        let display = (shift == .off) ? char : char.uppercased()
        let b = KeyButton(type: .system)
        b.setTitle(display, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .secondarySystemBackground
        b.layer.cornerRadius = 8
        b.variants = variants
        b.accessibilityLabel = char
        b.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
        if !variants.isEmpty { addLongPress(to: b) }
        return b
    }

    private func functionKey(_ title: String, action: Selector, flex: CGFloat = 1.0) -> KeyButton {
        let b = KeyButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .tertiarySystemBackground
        b.layer.cornerRadius = 8
        b.addTarget(self, action: action, for: .touchUpInside)
        b.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return b
    }

    private func addLongPress(to button: KeyButton) {
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        lp.minimumPressDuration = 0.35
        button.addGestureRecognizer(lp)
    }

    // MARK: Letters page

    private func buildLetters() {
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
            row1.append(letterKey(ch, variants: v))
        }
        mainStack.addArrangedSubview(makeRow(row1))

        var row2: [KeyButton] = []
        for ch in ["a","s","d","f","g","h","j","k","l"] {
            var v: [String] = []
            if ch == "a" { v = ["á"] }
            row2.append(letterKey(ch, variants: v))
        }
        mainStack.addArrangedSubview(makeRow(row2))

        // Row 3: SHIFT | z x c v b n m | DELETE
        let shiftBtn = functionKey(shift == .off ? "⇧" : "⇪", action: #selector(shiftTapped(_:)))
        shiftBtn.isShiftKey = true
        if shift != .off { shiftBtn.backgroundColor = .systemOrange }
        var row3: [KeyButton] = [shiftBtn]
        for ch in ["z","x","c","v","b","n","m"] {
            // Brian's call: no Ñ key — Ñ lives on long-press N instead.
            row3.append(letterKey(ch, variants: ch == "n" ? ["ñ"] : []))
        }
        let del = functionKey("⌫", action: #selector(deleteTapped))
        del.isDeleteKey = true
        addDeleteHold(to: del)
        row3.append(del)
        let row3Stack = makeRow(row3)
        shiftBtn.widthAnchor.constraint(equalTo: row3Stack.heightAnchor, multiplier: 1.35).isActive = true
        del.widthAnchor.constraint(equalTo: row3Stack.heightAnchor, multiplier: 1.35).isActive = true
        mainStack.addArrangedSubview(row3Stack)

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
        addDeleteHold(to: del)
        row3.append(del)
        mainStack.addArrangedSubview(makeRow(row3))
        mainStack.addArrangedSubview(bottomRow(modeTitle: "ABC", modeAction: #selector(showLetters)))
    }

    private func punctKey(_ char: String) -> KeyButton {
        let b = letterKey(char)
        b.backgroundColor = .secondarySystemBackground
        return b
    }

    // MARK: Bottom row (shared)

    private func bottomRow(modeTitle: String, modeAction: Selector) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = 5
        row.heightAnchor.constraint(equalToConstant: 54).isActive = true

        let globe = KeyButton(type: .system)
        globe.setTitle("🌐", for: .normal)
        globe.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        globe.backgroundColor = .tertiarySystemBackground
        globe.layer.cornerRadius = 8
        globe.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        globe.widthAnchor.constraint(equalToConstant: 48).isActive = true
        row.addArrangedSubview(globe)

        let modeBtn = functionKey(modeTitle, action: modeAction)
        modeBtn.widthAnchor.constraint(equalToConstant: 52).isActive = true
        row.addArrangedSubview(modeBtn)

        let comma = punctKey(",")
        comma.variants = [".", "?", "!", "¿", "¡"]
        addLongPress(to: comma)
        comma.widthAnchor.constraint(equalToConstant: 40).isActive = true
        row.addArrangedSubview(comma)

        let space = KeyButton(type: .system)
        space.setTitle("space", for: .normal)
        space.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        space.setTitleColor(.label, for: .normal)
        space.backgroundColor = .secondarySystemBackground
        space.layer.cornerRadius = 8
        space.addTarget(self, action: #selector(spaceTapped), for: .touchUpInside)
        row.addArrangedSubview(space)

        let period = punctKey(".")
        period.variants = [",", "?", "!", "¿", "¡", "…"]
        addLongPress(to: period)
        period.widthAnchor.constraint(equalToConstant: 40).isActive = true
        row.addArrangedSubview(period)

        // The buffer: a deliberate dead gap before Return (Brian's danger zone).
        let gap = UIView()
        gap.widthAnchor.constraint(equalToConstant: 10).isActive = true
        row.addArrangedSubview(gap)

        let ret = KeyButton(type: .system)
        ret.setTitle("⏎", for: .normal)
        ret.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        ret.setTitleColor(.label, for: .normal)
        ret.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.35)
        ret.layer.cornerRadius = 8
        ret.widthAnchor.constraint(equalToConstant: 56).isActive = true
        ret.addTarget(self, action: #selector(returnTapped), for: .touchUpInside)
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
        heightConstraint.constant = 305
    }

    @objc private func hideVariants() {
        variantStrip.isHidden = true
        heightConstraint.constant = 252
    }

    @objc private func variantTapped(_ sender: UIButton) {
        guard let s = sender.title(for: .normal) else { return }
        hapticLight.impactOccurred()
        insertTextSmart(s)
        hideVariants()
    }

    // MARK: - Actions

    private func insertTextSmart(_ text: String) {
        var out = text
        if text.count == 1, text.first!.isLetter {
            out = (shift == .off) ? text.lowercased() : text.uppercased()
        }
        textDocumentProxy.insertText(out)
        if shift == .once, text.count == 1, text.first!.isLetter {
            shift = .off
            buildKeyboard()
        }
    }

    @objc private func letterTapped(_ sender: KeyButton) {
        guard let label = sender.accessibilityLabel ?? sender.title(for: .normal) else { return }
        hapticLight.impactOccurred()
        insertTextSmart(label)
    }

    @objc private func spaceTapped() {
        hapticMedium.impactOccurred()   // space feels different on purpose
        textDocumentProxy.insertText(" ")
        autoShiftIfNeeded()
    }

    @objc private func returnTapped() {
        hapticSelect.selectionChanged()
        textDocumentProxy.insertText("\n")
    }

    @objc private func deleteTapped() {
        hapticSelect.selectionChanged()
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
        hapticSelect.selectionChanged()
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
        buildKeyboard()
    }

    @objc private func showNumbers() { hapticSelect.selectionChanged(); mode = .numbers; buildKeyboard() }
    @objc private func showSymbols() { hapticSelect.selectionChanged(); mode = .symbols; buildKeyboard() }
    @objc private func showLetters() { hapticSelect.selectionChanged(); mode = .letters; buildKeyboard() }

    // MARK: - Auto-shift (never autocorrect — capitals only)

    private func autoShiftIfNeeded() {
        guard mode == .letters, shift == .off else { return }
        let context = textDocumentProxy.documentContextBeforeInput ?? ""
        if context.isEmpty || context.hasSuffix(". ") || context.hasSuffix("! ") || context.hasSuffix("? ") || context.hasSuffix("\n") {
            shift = .once
            buildKeyboard()
        }
    }
}
