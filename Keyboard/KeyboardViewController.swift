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
    /// v0.9: a space-bar trackpad session is walking the cursor (set
    /// by the VC); while it runs, touches must not flick or slide.
    static var trackpadMode = false
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
        // v0.9: during a trackpad session the finger's travel moves the
        // cursor — it must not flick an Enter or slide-commit letters.
        if KeyButton.trackpadMode { return }
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
    /// v0.6: the variant strip's owner, captured in showVariants FROM
    /// THE BUTTON ITSELF, plus the exact document character it may
    /// replace (nil when the base char is verifiably NOT the document's
    /// last char). variantTapped trusts ONLY this — v0.5 forensics
    /// proved the touch-down pending state can point at the wrong key.
    private weak var variantOwner: KeyButton?
    private var variantExpected: String? = nil
    /// v0.6 (Brian): slide-commit ON/OFF switch (panel). Default ON;
    /// he wants to A/B it — his suite log had ZERO slide events and his
    /// full log only 3 in ~2,000 taps, so the test is cheap and clean.
    private let slidePrefKey = "bk_slide_on_v1"
    private lazy var slideOn: Bool = settingBool(slidePrefKey, default: true)
    /// v0.8 (Brian): his words live in ONE drawer shared between the
    /// app and the keyboard (App Groups), so he can add and delete
    /// words from inside the app and the keyboard just uses that list.
    /// Under SideStore the sharing is a HYPOTHESIS until he tests it
    /// on the phone; if the shared drawer cannot be opened, wordStore
    /// falls back to the keyboard's own drawer and nothing changes.
    static let appGroupID = "group.com.brianklauer.briankeys"
    lazy var wordStore: UserDefaults = UserDefaults(suiteName: KeyboardViewController.appGroupID) ?? .standard
    /// v0.9 (Brian): his switches live in the APP now (Opciones page)
    /// and travel through the same shared drawer as his words. The
    /// keyboard reads shared-first, local-second: a switch he flips in
    /// the app wins, and if the drawer does not survive SideStore his
    /// last in-keyboard values still apply.
    func settingBool(_ key: String, default def: Bool) -> Bool {
        if let v = wordStore.object(forKey: key) as? Bool { return v }
        if let v = UserDefaults.standard.object(forKey: key) as? Bool { return v }
        return def
    }
    private func refreshSettings() {
        prudentEnabled = settingBool(prudentKey, default: false)
        popupEnabled = settingBool(popupKey, default: true)
        suggEnabled = settingBool(suggKey, default: true)
        slideOn = settingBool(slidePrefKey, default: true)
        keyRowH = CGFloat(min(66, max(46, settingInt(keyHKey, default: 56))))
        keyGap = CGFloat(min(6, max(0, settingInt(keyGapKey, default: 0))))
        bordersOn = settingBool(bordersKey, default: true)
    }
    /// v0.6 (Brian): personal dictionary — words he pins himself
    /// (long-press a suggestion chip). They outrank learned words.
    private let personalKey = "bk_personal_v1"
    private lazy var personal: Set<String> = Set(wordStore.stringArray(forKey: personalKey) ?? [])
    private var wordsPage = 0
    /// v0.6 (Brian): next-word prediction from HIS phrases — counts of
    /// (previous word → next word), learned when a word is completed.
    private let bigramKey = "bk_bigrams_v1"
    private lazy var bigrams: [String: [String: Int]] = wordStore.dictionary(forKey: bigramKey) as? [String: [String: Int]] ?? [:]
    private var lastCompletedWord: String? = nil
    /// v0.9 (Brian): ONE active language — the bilingual bar confused
    /// him the same way Apple's did ("over" offered before "ocurre").
    /// Spanish by default; he flips it in the 123 panel when he wants
    /// English. His own words (seeds, pinned, learned) always apply.
    private let langKey = "bk_lang_v1"
    private lazy var lang: String = wordStore.string(forKey: langKey)
        ?? UserDefaults.standard.string(forKey: langKey) ?? "es"
    /// v0.11 (Brian): the VISUAL EDITOR lives in the keyboard itself.
    /// The app-as-control-centre died with the shared drawer (the
    /// unsigned SideStore build drops the App Groups entitlement), so
    /// his switches, key size, gaps and borders are edited HERE, on the
    /// keyboard he is looking at, and saved in the keyboard's own store.
    private let keyHKey = "bk_key_h_v1"
    private let keyGapKey = "bk_key_gap_v1"
    private let bordersKey = "bk_borders_v1"
    private var keyRowH: CGFloat = 56
    private var keyGap: CGFloat = 0
    private var bordersOn: Bool = true
    private var editorOpen = false
    // Staged editor values: nothing persists until he taps Listo.
    private var edPrudent = false, edPopup = true, edSugg = true, edSlide = true
    private var edH: CGFloat = 56, edGap: CGFloat = 0, edBorders = true
    /// v0.12 (Brian): the big words editor — a full page like the
    /// visual editor, for his OWN words only (the old 5-per-page panel
    /// mixed ~750 learned words in and was useless for managing them).
    private var wordsOpen = false
    private var addingWord = false
    private var editorPreview: UIStackView?
    private var editorHLabel: UILabel?
    private var editorGapLabel: UILabel?
    /// Total keyboard height at the current key size/gaps, anchored on
    /// the known-good 315 at 56pt rows with zero gap.
    private var kbBaseHeight: CGFloat { 315 + (keyRowH - 56) * 4 + keyGap * 3 }
    func settingInt(_ key: String, default def: Int) -> Int {
        if let v = wordStore.object(forKey: key) as? Int { return v }
        if let v = UserDefaults.standard.object(forKey: key) as? Int { return v }
        return def
    }
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
        wordStore.dictionary(forKey: learnedKey) as? [String: Int] ?? [:]
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
    private lazy var prudentEnabled: Bool = settingBool(prudentKey, default: false)
    private lazy var foldedESSet: Set<String> = Set(foldedES)
    private lazy var foldedENSet: Set<String> = Set(foldedEN)
    private lazy var foldedES: [String] = WordLists.es.map { fold($0) }
    private lazy var foldedEN: [String] = WordLists.en.map { fold($0) }
    private lazy var foldedSeeds: [String] = seedWords.map { fold($0) }

    private func fold(_ s: String) -> String {
        s.lowercased().folding(options: .diacriticInsensitive, locale: nil)
    }

    /// v0.8: the first time the shared drawer opens, carry his existing
    /// words (personal + learned + bigrams) over from the keyboard's
    /// own drawer. Runs once; from then on the app and the keyboard
    /// read and write the same drawer.
    private func migrateWordsToSharedDrawer() {
        guard let shared = UserDefaults(suiteName: KeyboardViewController.appGroupID) else { return }
        let local = UserDefaults.standard
        if shared.object(forKey: "bk_migrated_v08") == nil {
            if shared.stringArray(forKey: personalKey) == nil,
               let mine = local.stringArray(forKey: personalKey) {
                shared.set(mine, forKey: personalKey)
            }
            if shared.dictionary(forKey: learnedKey) == nil,
               let mine = local.dictionary(forKey: learnedKey) {
                shared.set(mine, forKey: learnedKey)
            }
            if shared.dictionary(forKey: bigramKey) == nil,
               let mine = local.dictionary(forKey: bigramKey) {
                shared.set(mine, forKey: bigramKey)
            }
            shared.set(true, forKey: "bk_migrated_v08")
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        migrateWordsToSharedDrawer()   // v0.8: before anything reads his words
        refreshSettings()   // v0.9: his switches, as last set in the app
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
                                        multiplier: 1.0, constant: kbBaseHeight)
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
            // v0.6: long-press a chip = pin that word as HIS (personal
            // dictionary, top priority in future suggestions).
            let chipLP = UILongPressGestureRecognizer(target: self, action: #selector(chipLongPressed(_:)))
            chipLP.minimumPressDuration = 0.45
            c.addGestureRecognizer(chipLP)
            suggestionBar.addArrangedSubview(c)
            return c
        }

        buildKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshSettings()   // v0.9: pick up switches he flipped in the app
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

    /// v0.13 queued (Brian, 2026-11-14): page changes must be INSTANT.
    /// His report: switching letters/capitals/numbers flashed the whole
    /// keyboard white for a moment — visually confusing, felt like the
    /// keys were blank. There is NO explicit animation in this code
    /// (verified: no UIView.animate anywhere); the working hypothesis
    /// is that the rebuild tears the whole stack down and rebuilds it,
    /// and a frame of empty tray shows through between the two. The
    /// cure below runs the entire swap with actions disabled and forces
    /// layout inside the same transaction, so the new page lands in a
    /// single frame with nothing in between.
    private func buildKeyboard() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        UIView.performWithoutAnimation {
            buildKeyboardNow()
            view.layoutIfNeeded()
        }
        CATransaction.commit()
    }

    private func buildKeyboardNow() {
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

        mainStack.spacing = keyGap
        mainStack.addArrangedSubview(suggestionBar)

        // Variants strip (hidden until a long-press).
        variantStrip = UIStackView()
        variantStrip.axis = .horizontal
        variantStrip.distribution = .fillEqually
        variantStrip.spacing = 5
        variantStrip.isHidden = true
        variantStrip.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mainStack.addArrangedSubview(variantStrip)

        // Second strip (hidden unless the log panel is open, v0.2).
        panelStrip = UIStackView()
        panelStrip.axis = .horizontal
        panelStrip.distribution = .fillEqually
        panelStrip.spacing = 5
        panelStrip.isHidden = true
        panelStrip.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mainStack.addArrangedSubview(panelStrip)

        // v0.11/v0.12: the editor pages replace the key rows.
        if wordsOpen {
            buildWordsEditor()
        } else if editorOpen {
            buildEditor()
        } else {
            if mode != .emoji { heightConstraint.constant = kbBaseHeight }
            switch mode {
            case .letters: buildLetters()
            case .numbers: buildNumbers()
            case .symbols: buildSymbols()
            case .emoji: buildEmoji()
            }
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
        row.spacing = keyGap   // v0.4: keys touch — no dead gap to fall into
        row.heightAnchor.constraint(equalToConstant: keyRowH).isActive = true
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
        outline(b)
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
        outline(b)
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
    private var emojiPage = 0

    private func buildEmoji() {
        // v0.13 (Brian): the FULL emoji set (EmojiData: 3,963) with a
        // category jump strip and paging — the old page had 32.
        let all = EmojiData.all
        let perPage = 32
        let pages = (all.count + perPage - 1) / perPage
        emojiPage = min(max(0, emojiPage), pages - 1)

        // Category jumps.
        let jumps = UIStackView()
        jumps.axis = .horizontal
        jumps.distribution = .fillEqually
        jumps.spacing = keyGap
        jumps.heightAnchor.constraint(equalToConstant: 36).isActive = true
        for (i, label) in EmojiData.jumpLabels.enumerated() {
            let b = UIButton(type: .system)
            b.setTitle(label, for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 20)
            b.backgroundColor = keyColor
            b.layer.cornerRadius = 8
            outline(b)
            b.tag = EmojiData.jumpIndices[i] / perPage
            b.addTarget(self, action: #selector(emojiJumpTapped(_:)), for: .touchUpInside)
            jumps.addArrangedSubview(b)
        }
        mainStack.addArrangedSubview(jumps)

        let slice = Array(all.dropFirst(emojiPage * perPage).prefix(perPage))
        for r in 0..<4 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = keyGap   // zero-gap tiling, like the letter keys
            row.heightAnchor.constraint(equalToConstant: keyRowH).isActive = true
            for c in 0..<8 {
                let idx = r * 8 + c
                let b = UIButton(type: .system)
                if idx < slice.count {
                    b.setTitle(slice[idx], for: .normal)
                    b.titleLabel?.font = .systemFont(ofSize: 26)
                    b.backgroundColor = keyColor
                    b.layer.cornerRadius = 12
                    outline(b)
                    b.addTarget(self, action: #selector(emojiTouchDown(_:)), for: .touchDown)
                    b.addTarget(self, action: #selector(emojiTouchUp(_:)), for: [.touchUpOutside, .touchCancel])
                    b.addTarget(self, action: #selector(emojiTapped(_:)), for: .touchUpInside)
                } else {
                    b.backgroundColor = .clear
                    b.isEnabled = false
                }
                row.addArrangedSubview(b)
            }
            mainStack.addArrangedSubview(row)
        }

        // Pager.
        let pager = UIStackView()
        pager.axis = .horizontal
        pager.distribution = .fillEqually
        pager.spacing = keyGap
        pager.heightAnchor.constraint(equalToConstant: 36).isActive = true
        pager.addArrangedSubview(stripButton("⬅", #selector(emojiPrevTapped)))
        let pageLabel = UILabel()
        pageLabel.text = "Page \(emojiPage + 1)/\(pages)"
        pageLabel.font = .systemFont(ofSize: 14, weight: .medium)
        pageLabel.textColor = .label
        pageLabel.textAlignment = .center
        pager.addArrangedSubview(pageLabel)
        pager.addArrangedSubview(stripButton("➡", #selector(emojiNextTapped)))
        mainStack.addArrangedSubview(pager)

        // Bottom row: ABC back, a space, and delete (hold repeats).
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = keyGap
        row.heightAnchor.constraint(equalToConstant: keyRowH).isActive = true
        let abc = functionKey("ABC", action: #selector(showLetters))
        abc.widthAnchor.constraint(equalToConstant: 64).isActive = true
        row.addArrangedSubview(abc)
        let space = KeyButton(type: .system)
        space.setTitle("space", for: .normal)
        space.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        space.setTitleColor(.label, for: .normal)
        paint(space, normal: keyColor, pressed: keyPressedColor)
        space.layer.cornerRadius = 12
        outline(space)
        addFlickHint(to: space)
        space.isSpaceKey = true   // v0.5: the flick works on this bar too
        space.onFlickDown = { [weak self] in self?.spaceFlickedToEnter() }
        space.addTarget(self, action: #selector(spaceTapped), for: .touchDown)
        // v0.9: the trackpad lives on this bar too.
        let spaceLP = UILongPressGestureRecognizer(target: self, action: #selector(spaceLongPressed(_:)))
        spaceLP.minimumPressDuration = 0.4
        space.addGestureRecognizer(spaceLP)
        row.addArrangedSubview(space)
        let del = functionKey("⌫", action: #selector(deleteTapped))
        del.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addDeleteHold(to: del)
        row.addArrangedSubview(del)
        mainStack.addArrangedSubview(row)

        // The jump strip + pager make this page taller than the letters.
        heightConstraint.constant = kbBaseHeight + 72
    }

    @objc private func emojiJumpTapped(_ sender: UIButton) {
        emojiPage = sender.tag
        buildKeyboard()
    }

    @objc private func emojiPrevTapped() {
        if emojiPage > 0 { emojiPage -= 1 }
        buildKeyboard()
    }

    @objc private func emojiNextTapped() {
        let pages = (EmojiData.all.count + 31) / 32
        if emojiPage < pages - 1 { emojiPage += 1 }
        buildKeyboard()
    }
    private func bottomRow(modeTitle: String, modeAction: Selector) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = keyGap   // v0.4 zero-gap tiling applies to this row too
        row.heightAnchor.constraint(equalToConstant: keyRowH).isActive = true

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
        outline(space)
        space.haptic = .heavySpace
        space.isSpaceKey = true
        // v0.4: space no longer steals edge points — zero-gap tiling.
        space.addTarget(self, action: #selector(spaceTapped), for: .touchDown)   // commit on contact, like the letters
        space.addTarget(self, action: #selector(keyTouchedDown(_:)), for: .touchDown)
        // v0.9: long-press space = trackpad (walk the cursor). The
        // corrector's switch moved to the app's Opciones page.
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
        addFlickHint(to: space)   // v0.6: the hint finally ships
        row.addArrangedSubview(space)

        // v0.5 (Brian): THE RETURN KEY IS GONE. It was his danger zone
        // from day one (hit by accident when aiming for space or
        // delete); now the space bar runs to the right edge — where his
        // thumb lands anyway — and Enter lives in the downward flick on
        // the bar (see spaceFlickedToEnter). Flick only, no long-press
        // Enter: the long-press is the trackpad now (v0.9).

        return row
    }

    /// v0.6 (Brian): a thin dark outline on every key, so the gapless
    /// keys stay visually distinct. NO gaps come back — it's paint,
    /// not space. Layer-level, so the baked key images can't eat it.
    private func outline(_ b: UIButton) {
        b.layer.borderWidth = bordersOn ? 1 : 0
        b.layer.borderColor = UIColor.black.withAlphaComponent(0.55).cgColor
    }

    /// v0.6 (Brian): the ⏎↓ flick hint the v0.5 mockup promised and
    /// the code forgot — small, at the space bar's right end.
    private func addFlickHint(to space: KeyButton) {
        let hint = UILabel()
        hint.text = "⏎↓"
        hint.font = .systemFont(ofSize: 14, weight: .semibold)
        hint.textColor = .secondaryLabel
        hint.isUserInteractionEnabled = false
        hint.translatesAutoresizingMaskIntoConstraints = false
        space.addSubview(hint)
        NSLayoutConstraint.activate([
            hint.trailingAnchor.constraint(equalTo: space.trailingAnchor, constant: -12),
            hint.centerYAnchor.constraint(equalTo: space.centerYAnchor)
        ])
    }

    // MARK: - Variants strip

    @objc private func longPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began, let b = gesture.view as? KeyButton, !b.variants.isEmpty else { return }
        showVariants(for: b)
    }

    private func showVariants(for button: KeyButton) {
        // v0.6: capture the strip's owner HERE, from the button itself,
        // and work out NOW whether its base char is verifiably the
        // document's last char. variantTapped trusts only this — never
        // the touch-down pending state, which v0.5's log proved can
        // point at the previous key when a touch-down goes unregistered.
        variantOwner = button
        variantExpected = nil
        if let base = button.accessibilityLabel {
            let context = textDocumentProxy.documentContextBeforeInput ?? ""
            if let last = context.last, fold(String(last)) == fold(base) {
                variantExpected = String(last)
            }
        }
        for arranged in variantStrip.arrangedSubviews {
            variantStrip.removeArrangedSubview(arranged)
            arranged.removeFromSuperview()
        }
        for variant in button.variants {
            let vb = UIButton(type: .system)
            vb.setTitle(variant, for: .normal)
            vb.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
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
        heightConstraint.constant = kbBaseHeight + 47
    }

    @objc private func hideVariants() {
        addingWord = false   // v0.12: the add-word strip is gone too
        variantStrip.isHidden = true
        panelStrip?.isHidden = true
        heightConstraint.constant = kbBaseHeight
        variantOwner = nil
        variantExpected = nil
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
        // v0.6: delete ONLY the strip owner's own base char, captured
        // in showVariants and re-verified against the document right
        // now. If the base never landed (an unregistered touch-down),
        // expected is nil and the variant is inserted with NO delete —
        // by construction this can never eat a neighbour's letter.
        var deleted = false
        if variantOwner != nil, let exp = variantExpected,
           let last = (textDocumentProxy.documentContextBeforeInput ?? "").last,
           String(last) == exp {
            textDocumentProxy.deleteBackward()
            if !localWord.isEmpty { localWord.removeLast() }
            deleted = true
        }
        variantOwner = nil
        variantExpected = nil
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
        wordStore.set(learned, forKey: learnedKey)
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
        noteCompleted(final)   // v0.6: feed the bigram counts
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
        // v0.9: fixes are drawn from the ACTIVE language only.
        let pool = lang == "en" ? WordLists.en : WordLists.es
        let poolFolded = lang == "en" ? foldedEN : foldedES
        for i in 0..<min(1200, pool.count) { consider(pool[i], poolFolded[i]) }
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

    // MARK: - v0.9: space-bar trackpad (Brian)

    /// Long-press on space = trackpad: hold the bar and drag sideways
    /// to walk the cursor letter by letter through text already
    /// written — the iPhone gesture he loves. This REPLACES the
    /// prudent corrector's switch, which moved to the app's Opciones
    /// page (his call: the long-press is ONLY the cursor now).
    private var trackpadLastX: CGFloat = 0
    private var trackpadRemainder: CGFloat = 0

    @objc private func spaceLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard let bar = gesture.view else { return }
        switch gesture.state {
        case .began:
            KeyButton.trackpadMode = true
            trackpadLastX = gesture.location(in: bar).x
            trackpadRemainder = 0
            // The bar commits its space on touch-down, before this
            // gesture is even recognised. If THIS touch just typed that
            // trailing space, take it back so the walk starts where
            // his text actually ended. A ". " from a double-space is a
            // sentence end — never half-eaten.
            if let last = lastSpaceAt, Date().timeIntervalSince(last) < 1.2 {
                let ctx = textDocumentProxy.documentContextBeforeInput ?? ""
                if ctx.hasSuffix(" "), !ctx.hasSuffix(". ") {
                    textDocumentProxy.deleteBackward()
                    lastSpaceAt = nil
                    localWord = currentWord()
                }
            }
            flashBar("Cursor ↔", "drag")
        case .changed:
            let x = gesture.location(in: bar).x
            trackpadRemainder += x - trackpadLastX
            trackpadLastX = x
            let step: CGFloat = 9   // points of drag per letter walked
            while trackpadRemainder >= step {
                textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
                trackpadRemainder -= step
            }
            while trackpadRemainder <= -step {
                textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
                trackpadRemainder += step
            }
        case .ended, .cancelled, .failed:
            KeyButton.trackpadMode = false
            updateSuggestions()
        default:
            break
        }
    }

    @objc private func refreshBar() { updateSuggestions() }

    /// v0.12: true when two folded words are exactly one edit apart
    /// (insertion, deletion, substitution or transposition).
    private func editDistanceOne(_ a: String, _ b: String) -> Bool {
        let x = Array(a), y = Array(b)
        if abs(x.count - y.count) > 1 { return false }
        if x.count == y.count {
            var diffs: [Int] = []
            for i in x.indices where x[i] != y[i] { diffs.append(i) }
            if diffs.count == 1 { return true }
            if diffs.count == 2 {
                let i = diffs[0], j = diffs[1]
                return j == i + 1 && x[i] == y[j] && x[j] == y[i]
            }
            return false
        }
        let (short, long) = x.count < y.count ? (x, y) : (y, x)
        var i = 0, j = 0, skipped = false
        while i < short.count {
            if short[i] == long[j] {
                i += 1; j += 1
            } else {
                if skipped { return false }
                skipped = true
                j += 1
            }
        }
        return true
    }

    private func computeSuggestions(for prefix: String) -> [String] {
        if prefix.isEmpty {
            // No word in progress: v0.6 — first, what HIS phrases say
            // comes next (bigrams); then his most-used learned words.
            var out: [String] = []
            if let prev = lastCompletedWord?.lowercased(),
               let followers = bigrams[prev] {
                out += followers.sorted { $0.value > $1.value }.prefix(3).map { $0.key }
            }
            if out.count < 3 {
                for w in learned.sorted { $0.value > $1.value } where !out.contains(w.key) {
                    out.append(w.key)
                    if out.count == 3 { break }
                }
            }
            return out
        }
        let fp = fold(prefix)
        var out: [String] = []
        var seenAt: [String: Int] = [:]
        func accented(_ s: String) -> Bool {
            s.folding(options: .diacriticInsensitive, locale: nil) != s
        }
        func offer(_ surface: String) {
            let f = fold(surface)
            if let idx = seenAt[f] {
                // v0.9 (Brian): the accented twin wins. His learned
                // unaccented "mas" used to shadow the dictionary's
                // "más" — now the form WITH the tilde replaces it.
                if !accented(out[idx]), accented(surface) { out[idx] = surface }
                return
            }
            seenAt[f] = out.count
            out.append(surface)
        }
        for (i, seed) in seedWords.enumerated() where foldedSeeds[i].hasPrefix(fp) {
            offer(seed)
            if out.count == 3 { return out }
        }
        // v0.6: his pinned personal words outrank merely-learned ones.
        for w in personal.sorted { (learned[$0] ?? 0) > (learned[$1] ?? 0) }
        where fold(w).hasPrefix(fp) {
            offer(w)
            if out.count == 3 { return out }
        }
        let learnedMatches = learned
            .filter { (learnedFolded[$0.key] ?? fold($0.key)).hasPrefix(fp) }
            .sorted { $0.value > $1.value }
        for m in learnedMatches {
            offer(m.key)
            if out.count == 3 { return out }
        }
        // v0.9 (Brian): ONE dictionary — the active language's.
        let dictWords = lang == "en" ? WordLists.en : WordLists.es
        let dictFolded = lang == "en" ? foldedEN : foldedES
        for (i, w) in dictWords.enumerated() where dictFolded[i].hasPrefix(fp) {
            offer(w)
            if out.count == 3 { return out }
        }
        // v0.12 (Brian): near-word OFFERS. Prefix matching alone could
        // never offer "que" for his "qie" — when the prefix well runs
        // dry, fill the free chips with words one edit away (folded),
        // in dictionary order (= frequency), scanning the top 4000.
        // Offers only: nothing applies without his tap.
        if out.count < 3, prefix.count >= 3 {
            for (i, w) in dictWords.enumerated().prefix(4000)
            where !dictFolded[i].hasPrefix(fp) && editDistanceOne(fp, dictFolded[i]) {
                offer(w)
                if out.count == 3 { break }
            }
        }
        return out
    }

    /// v0.9 (Brian): a chip shows the word AS IT WILL BE INSERTED —
    /// capitalised at a sentence start (Shift on), plain mid-sentence.
    private func displayForm(_ w: String) -> String {
        guard shift != .off, let f = w.first else { return w }
        return f.uppercased() + w.dropFirst()
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
                chip.setTitle(displayForm(currentSuggestions[i]), for: .normal)
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
        noteCompleted(word)   // v0.6: a tapped chip also completes a word
        // v0.7 (Brian): NO trailing space after a chip — it left a space
        // before any punctuation typed next ("palabra ,"). He adds the
        // space himself when he wants one.
        autoShiftIfNeeded()
        updateSuggestions()
    }

    // MARK: - v0.6: bigrams, personal dictionary, words manager

    /// A word was completed: count the pair (previous → this) so the
    /// bar can predict HIS next word, and remember it as the previous.
    private func noteCompleted(_ word: String) {
        if let prev = lastCompletedWord?.lowercased(), !prev.isEmpty,
           prev != word.lowercased() {
            var followers = bigrams[prev] ?? [:]
            followers[word, default: 0] += 1
            bigrams[prev] = followers
            if bigrams.count > 900 {   // prune one-hit wonders
                bigrams = bigrams.filter { $0.value.values.reduce(0, +) > 1 }
            }
            wordStore.set(bigrams, forKey: bigramKey)
        }
        lastCompletedWord = word
    }

    /// Long-press on a suggestion chip: pin the word as personal.
    @objc private func chipLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              let chip = gesture.view as? UIButton,
              chip.tag < currentSuggestions.count else { return }
        let word = currentSuggestions[chip.tag]
        personal.insert(word)
        wordStore.set(Array(personal), forKey: personalKey)
        if logEnabled { logEvent(k: "CFG", m: "pin-word", viewPoint: .zero, frame: nil) }
        chip.setTitle("📌 " + word, for: .normal)
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(refreshBar),
                                               object: nil)
        perform(#selector(refreshBar), with: nil, afterDelay: 1.0)
    }

    /// Every word the keyboard treats as his: pinned first, then
    /// learned by frequency.
    private func allPersonalWords() -> [String] {
        var set = Set(learned.keys)
        set.formUnion(personal)
        return set.sorted { a, b in
            let pa = personal.contains(a) ? 1 : 0
            let pb = personal.contains(b) ? 1 : 0
            if pa != pb { return pa > pb }
            return (learned[a] ?? 0) > (learned[b] ?? 0)
        }
    }

    @objc private func wordsPanelTapped() {
        wordsPage = 0
        showWordsPanel()
    }

    /// The words manager, inside the panel strips: a page of his words
    /// (tap one to DELETE it — that's how a badly-learned word dies)
    /// plus page navigation. Pinning happens by long-pressing a chip.
    private func showWordsPanel() {
        let words = allPersonalWords()
        let pageSize = 5
        let pages = max(1, (words.count + pageSize - 1) / pageSize)
        wordsPage = min(max(wordsPage, 0), pages - 1)
        for arranged in variantStrip.arrangedSubviews {
            variantStrip.removeArrangedSubview(arranged)
            arranged.removeFromSuperview()
        }
        if words.isEmpty {
            let b = stripButton("(no words yet)", #selector(wordsPanelTapped))
            b.isEnabled = false
            variantStrip.addArrangedSubview(b)
        } else {
            for (i, w) in words.enumerated()
            where i >= wordsPage * pageSize && i < wordsPage * pageSize + pageSize {
                let b = stripButton((personal.contains(w) ? "📌 " : "") + w,
                                    #selector(wordChipTapped(_:)))
                b.tag = i
                variantStrip.addArrangedSubview(b)
            }
        }
        let close = UIButton(type: .system)
        close.setTitle("✕", for: .normal)
        close.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        close.setTitleColor(.label, for: .normal)
        close.backgroundColor = .tertiarySystemBackground
        close.layer.cornerRadius = 8
        close.addTarget(self, action: #selector(hideVariants), for: .touchUpInside)
        variantStrip.addArrangedSubview(close)
        for arranged in panelStrip.arrangedSubviews {
            panelStrip.removeArrangedSubview(arranged)
            arranged.removeFromSuperview()
        }
        panelStrip.addArrangedSubview(stripButton("⬅", #selector(wordsPrevTapped)))
        let info = stripButton("Page \(wordsPage + 1)/\(pages) — tap a word to delete it",
                                #selector(wordsPanelTapped))
        info.isEnabled = false
        panelStrip.addArrangedSubview(info)
        panelStrip.addArrangedSubview(stripButton("➡", #selector(wordsNextTapped)))
        panelStrip.isHidden = false
        variantStrip.isHidden = false
        heightConstraint.constant = kbBaseHeight + 106
    }

    // v0.12: these two handlers, born with the old 5-per-page panel,
    // now page the big words editor (18 per page).
    @objc private func wordsPrevTapped() {
        if wordsPage > 0 { wordsPage -= 1 }
        if wordsOpen { buildKeyboard() } else { showWordsPanel() }
    }

    @objc private func wordsNextTapped() {
        let pages = max(1, (personal.count + 17) / 18)
        if wordsPage < pages - 1 { wordsPage += 1 }
        if wordsOpen { buildKeyboard() } else { showWordsPanel() }
    }

    @objc private func wordChipTapped(_ sender: UIButton) {
        let words = allPersonalWords()
        guard sender.tag < words.count else { return }
        let w = words[sender.tag]
        learned[w] = nil
        learnedFolded[w] = nil
        wordStore.set(learned, forKey: learnedKey)
        if personal.contains(w) {
            personal.remove(w)
            wordStore.set(Array(personal), forKey: personalKey)
        }
        if logEnabled { logEvent(k: "CFG", m: "word-del", viewPoint: .zero, frame: nil) }
        showWordsPanel()
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
    private lazy var popupEnabled: Bool = settingBool(popupKey, default: true)
    private lazy var suggEnabled: Bool = settingBool(suggKey, default: true)
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
            logEnabled ? "⏺ Recording YES" : "⏺ Record NO", #selector(logToggleTapped)))
        variantStrip.addArrangedSubview(stripButton("📋 Copy (\(logCount))", #selector(logCopyTapped)))
        variantStrip.addArrangedSubview(stripButton("🗑 Erase", #selector(logClearTapped)))
        variantStrip.addArrangedSubview(stripButton(
            lang == "en" ? "🌐 EN" : "🌐 ES", #selector(langToggleTapped)))
        variantStrip.addArrangedSubview(stripButton("🎨 Editor", #selector(editorTapped)))
        let close = UIButton(type: .system)
        close.setTitle("✕", for: .normal)
        close.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        close.setTitleColor(.label, for: .normal)
        close.backgroundColor = .tertiarySystemBackground
        close.layer.cornerRadius = 8
        close.addTarget(self, action: #selector(hideVariants), for: .touchUpInside)
        variantStrip.addArrangedSubview(close)

        // v0.11 (Brian): the switches moved INTO the visual editor
        // (next button) — the app's Opciones page could not reach the
        // keyboard without the shared drawer. This panel keeps the log
        // tools, the language flip and the way into the editor.
        panelStrip.isHidden = true
        variantStrip.isHidden = false
        heightConstraint.constant = kbBaseHeight + 47
        flashBar("MyKeys v0.13 Speed Lab", "")
    }

    @objc private func popupToggleTapped() {
        popupEnabled.toggle()
        UserDefaults.standard.set(popupEnabled, forKey: popupKey)
        if !popupEnabled { hidePopup() }
        if logEnabled { logEvent(k: "CFG", m: popupEnabled ? "popup-on" : "popup-off", viewPoint: .zero, frame: nil) }
        showLogPanel()
    }

    @objc private func slideToggleTapped() {
        slideOn.toggle()
        UserDefaults.standard.set(slideOn, forKey: slidePrefKey)
        if logEnabled { logEvent(k: "CFG", m: slideOn ? "slide-on" : "slide-off", viewPoint: .zero, frame: nil) }
        showLogPanel()
    }

    @objc private func suggToggleTapped() {
        suggEnabled.toggle()
        UserDefaults.standard.set(suggEnabled, forKey: suggKey)
        if logEnabled { logEvent(k: "CFG", m: suggEnabled ? "sugg-on" : "sugg-off", viewPoint: .zero, frame: nil) }
        updateSuggestions()
        showLogPanel()
    }

    /// v0.9 (Brian): the panel's one surviving switch — the language.
    @objc private func langToggleTapped() {
        lang = (lang == "es") ? "en" : "es"
        wordStore.set(lang, forKey: langKey)
        UserDefaults.standard.set(lang, forKey: langKey)
        if logEnabled { logEvent(k: "CFG", m: lang == "en" ? "lang-en" : "lang-es", viewPoint: .zero, frame: nil) }
        updateSuggestions()
        showLogPanel()   // rebuild so the label shows the new language
    }


    // MARK: - v0.11 Visual editor (Brian)

    @objc private func editorTapped() {
        edPrudent = prudentEnabled; edPopup = popupEnabled
        edSugg = suggEnabled; edSlide = slideOn
        edH = keyRowH; edGap = keyGap; edBorders = bordersOn
        editorOpen = true
        buildKeyboard()
    }

    private func editorRow(_ height: CGFloat) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        row.spacing = 6
        row.heightAnchor.constraint(equalToConstant: height).isActive = true
        mainStack.addArrangedSubview(row)
        return row
    }

    private func editorLabel(_ text: String, size: CGFloat = 15) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: size, weight: .medium)
        l.textColor = .label
        return l
    }

    private func editorPill(_ title: String, on: Bool, action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle("\(title): \(on ? "YES" : "NO")", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = on ? UIColor.systemTeal.withAlphaComponent(0.35)
                               : .tertiarySystemBackground
        b.layer.cornerRadius = 8
        b.addTarget(self, action: action, for: .touchUpInside)
        return b
    }

    private func buildEditor() {
        let head = editorRow(38)
        let title = editorLabel("🎨 Visual editor")
        title.font = .systemFont(ofSize: 17, weight: .bold)
        head.addArrangedSubview(title)
        let close = UIButton(type: .system)
        close.setTitle("✕", for: .normal)
        close.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        close.setTitleColor(.label, for: .normal)
        close.backgroundColor = .tertiarySystemBackground
        close.layer.cornerRadius = 8
        close.widthAnchor.constraint(equalToConstant: 44).isActive = true
        close.addTarget(self, action: #selector(editorCloseTapped), for: .touchUpInside)
        head.addArrangedSubview(close)

        let sw1 = editorRow(40)
        sw1.distribution = .fillEqually
        sw1.addArrangedSubview(editorPill("Corrector", on: edPrudent, action: #selector(edTogglePrudent)))
        sw1.addArrangedSubview(editorPill("Popup", on: edPopup, action: #selector(edTogglePopup)))
        let sw2 = editorRow(40)
        sw2.distribution = .fillEqually
        sw2.addArrangedSubview(editorPill("Suggestions", on: edSugg, action: #selector(edToggleSugg)))
        sw2.addArrangedSubview(editorPill("Slide", on: edSlide, action: #selector(edToggleSlide)))

        let sH = editorRow(44)
        let lH = editorLabel("Key size")
        lH.widthAnchor.constraint(equalToConstant: 86).isActive = true
        sH.addArrangedSubview(lH)
        let sliderH = UISlider()
        sliderH.minimumValue = 46; sliderH.maximumValue = 66
        sliderH.value = Float(edH)
        sliderH.addTarget(self, action: #selector(edHeightChanged(_:)), for: .valueChanged)
        sH.addArrangedSubview(sliderH)
        editorHLabel = editorLabel("\(Int(edH))")
        editorHLabel!.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sH.addArrangedSubview(editorHLabel!)

        let sG = editorRow(44)
        let lG = editorLabel("Gap")
        lG.widthAnchor.constraint(equalToConstant: 86).isActive = true
        sG.addArrangedSubview(lG)
        let sliderG = UISlider()
        sliderG.minimumValue = 0; sliderG.maximumValue = 6
        sliderG.value = Float(edGap)
        sliderG.addTarget(self, action: #selector(edGapChanged(_:)), for: .valueChanged)
        sG.addArrangedSubview(sliderG)
        editorGapLabel = editorLabel("\(Int(edGap))")
        editorGapLabel!.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sG.addArrangedSubview(editorGapLabel!)

        let sw3 = editorRow(40)
        sw3.distribution = .fillEqually
        sw3.addArrangedSubview(editorPill("Borders", on: edBorders, action: #selector(edToggleBorders)))
        let hint = editorLabel("Preview \u{2193}", size: 13)
        hint.textAlignment = .center
        sw3.addArrangedSubview(hint)

        editorPreview = UIStackView()
        editorPreview!.axis = .horizontal
        editorPreview!.distribution = .fillEqually
        editorPreview!.spacing = edGap
        editorPreview!.heightAnchor.constraint(equalToConstant: edH).isActive = true
        mainStack.addArrangedSubview(editorPreview!)
        refillEditorPreview()

        let bottom = editorRow(44)
        bottom.distribution = .fillEqually
        let words = UIButton(type: .system)
        words.setTitle("📖 Words", for: .normal)
        words.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        words.setTitleColor(.label, for: .normal)
        words.backgroundColor = keyColor
        words.layer.cornerRadius = 8
        words.addTarget(self, action: #selector(editorWordsTapped), for: .touchUpInside)
        bottom.addArrangedSubview(words)
        let done = UIButton(type: .system)
        done.setTitle("\u{2713} Done", for: .normal)
        done.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        done.setTitleColor(.white, for: .normal)
        done.backgroundColor = .systemTeal
        done.layer.cornerRadius = 8
        done.addTarget(self, action: #selector(editorDoneTapped), for: .touchUpInside)
        bottom.addArrangedSubview(done)

        heightConstraint.constant = kbBaseHeight + 106
    }

    private func refillEditorPreview() {
        guard let preview = editorPreview else { return }
        for arranged in preview.arrangedSubviews {
            preview.removeArrangedSubview(arranged)
            arranged.removeFromSuperview()
        }
        preview.spacing = edGap
        for c in preview.constraints where c.firstAttribute == .height { c.constant = edH }
        for ch in ["Q", "W", "E", "R", "T", "Y"] {
            let b = UIButton(type: .system)
            b.setTitle(ch, for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            b.setTitleColor(.label, for: .normal)
            b.backgroundColor = keyColor
            b.layer.cornerRadius = 12
            b.layer.borderWidth = edBorders ? 1 : 0
            b.layer.borderColor = UIColor.black.withAlphaComponent(0.55).cgColor
            b.isEnabled = false
            preview.addArrangedSubview(b)
        }
    }

    @objc private func edTogglePrudent() { edPrudent.toggle(); buildKeyboard() }
    @objc private func edTogglePopup() { edPopup.toggle(); buildKeyboard() }
    @objc private func edToggleSugg() { edSugg.toggle(); buildKeyboard() }
    @objc private func edToggleSlide() { edSlide.toggle(); buildKeyboard() }
    @objc private func edToggleBorders() { edBorders.toggle(); buildKeyboard() }

    @objc private func edHeightChanged(_ sender: UISlider) {
        edH = CGFloat(Int(sender.value.rounded()))
        editorHLabel?.text = "\(Int(edH))"
        refillEditorPreview()
    }

    @objc private func edGapChanged(_ sender: UISlider) {
        edGap = CGFloat(Int(sender.value.rounded()))
        editorGapLabel?.text = "\(Int(edGap))"
        refillEditorPreview()
    }

    @objc private func editorCloseTapped() {
        editorOpen = false
        buildKeyboard()
        hideVariants()
    }

    @objc private func editorWordsTapped() {
        editorOpen = false
        wordsOpen = true
        wordsPage = 0
        buildKeyboard()
    }

    @objc private func editorDoneTapped() {
        prudentEnabled = edPrudent; popupEnabled = edPopup
        suggEnabled = edSugg; slideOn = edSlide
        keyRowH = edH; keyGap = edGap; bordersOn = edBorders
        // Saved in BOTH of the keyboard's own stores, like the language
        // flip: the keyboard always reads its own last word (v0.11).
        for (key, val) in [(prudentKey, edPrudent), (popupKey, edPopup),
                           (suggKey, edSugg), (slidePrefKey, edSlide),
                           (bordersKey, edBorders)] {
            wordStore.set(val, forKey: key)
            UserDefaults.standard.set(val, forKey: key)
        }
        wordStore.set(Int(edH), forKey: keyHKey)
        UserDefaults.standard.set(Int(edH), forKey: keyHKey)
        wordStore.set(Int(edGap), forKey: keyGapKey)
        UserDefaults.standard.set(Int(edGap), forKey: keyGapKey)
        if !popupEnabled { hidePopup() }
        if logEnabled { logEvent(k: "CFG", m: "editor-done", viewPoint: .zero, frame: nil) }
        editorOpen = false
        buildKeyboard()
        hideVariants()
        flashBar("Editor applied \u{2713}", "")
    }


    // MARK: - v0.12 Words editor (Brian)

    private func sortedPersonal() -> [String] {
        personal.sorted {
            let c0 = learned[$0] ?? 0, c1 = learned[$1] ?? 0
            return c0 != c1 ? c0 > c1 : $0 < $1
        }
    }

    private func buildWordsEditor() {
        let head = editorRow(38)
        let title = editorLabel("📖 My words")
        title.font = .systemFont(ofSize: 17, weight: .bold)
        head.addArrangedSubview(title)
        let close = UIButton(type: .system)
        close.setTitle("✕", for: .normal)
        close.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        close.setTitleColor(.label, for: .normal)
        close.backgroundColor = .tertiarySystemBackground
        close.layer.cornerRadius = 8
        close.widthAnchor.constraint(equalToConstant: 44).isActive = true
        close.addTarget(self, action: #selector(wordsCloseTapped), for: .touchUpInside)
        head.addArrangedSubview(close)

        let sub = editorRow(24)
        let hint = editorLabel("Tap a word to delete it", size: 13)
        hint.textColor = .secondaryLabel
        sub.addArrangedSubview(hint)

        // 6 rows x 3 = 18 of HIS words per page — he asked for double
        // height, so this page is much taller than the letters page.
        let words = sortedPersonal()
        let perPage = 18
        let pages = max(1, (words.count + perPage - 1) / perPage)
        wordsPage = min(wordsPage, pages - 1)
        let slice = Array(words.dropFirst(wordsPage * perPage).prefix(perPage))
        for r in 0..<6 {
            let row = editorRow(46)
            row.distribution = .fillEqually
            for c in 0..<3 {
                let idx = r * 3 + c
                let b = UIButton(type: .system)
                if idx < slice.count {
                    b.setTitle(slice[idx], for: .normal)
                    b.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
                    b.setTitleColor(.label, for: .normal)
                    b.backgroundColor = keyColor
                    b.layer.cornerRadius = 8
                    if bordersOn { outline(b) }
                    b.accessibilityIdentifier = slice[idx]
                    b.addTarget(self, action: #selector(wordChipDeleteTapped(_:)), for: .touchUpInside)
                } else {
                    b.backgroundColor = .clear
                    b.isEnabled = false
                }
                row.addArrangedSubview(b)
            }
        }

        let pager = editorRow(40)
        pager.distribution = .fillEqually
        pager.addArrangedSubview(stripButton("⬅", #selector(wordsPrevTapped)))
        let pageLabel = editorLabel("Page \(wordsPage + 1)/\(pages)", size: 14)
        pageLabel.textAlignment = .center
        pager.addArrangedSubview(pageLabel)
        pager.addArrangedSubview(stripButton("➡", #selector(wordsNextTapped)))

        let actions = editorRow(44)
        actions.distribution = .fillEqually
        let add = UIButton(type: .system)
        add.setTitle("＋ Add", for: .normal)
        add.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        add.setTitleColor(.label, for: .normal)
        add.backgroundColor = keyColor
        add.layer.cornerRadius = 8
        add.addTarget(self, action: #selector(wordsAddTapped), for: .touchUpInside)
        actions.addArrangedSubview(add)
        let wipe = UIButton(type: .system)
        wipe.setTitle("🗑 Learned", for: .normal)
        wipe.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        wipe.setTitleColor(.label, for: .normal)
        wipe.backgroundColor = keyColor
        wipe.layer.cornerRadius = 8
        wipe.addTarget(self, action: #selector(wordsWipeLearnedTapped), for: .touchUpInside)
        actions.addArrangedSubview(wipe)

        let doneRow = editorRow(44)
        let done = UIButton(type: .system)
        done.setTitle("\u{2713} Done", for: .normal)
        done.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        done.setTitleColor(.white, for: .normal)
        done.backgroundColor = .systemTeal
        done.layer.cornerRadius = 8
        done.addTarget(self, action: #selector(wordsCloseTapped), for: .touchUpInside)
        doneRow.addArrangedSubview(done)

        heightConstraint.constant = kbBaseHeight + 270
    }

    @objc private func wordsCloseTapped() {
        wordsOpen = false
        buildKeyboard()
        hideVariants()
    }

    @objc private func wordChipDeleteTapped(_ sender: UIButton) {
        guard let w = sender.accessibilityIdentifier else { return }
        personal.remove(w)
        wordStore.set(Array(personal), forKey: personalKey)
        if logEnabled { logEvent(k: "CFG", m: "word-del", viewPoint: .zero, frame: nil) }
        buildKeyboard()
    }

    @objc private func wordsWipeLearnedTapped() {
        learned = [:]
        learnedFolded = [:]
        bigrams = [:]
        lastCompletedWord = nil
        wordStore.set(learned, forKey: learnedKey)
        wordStore.set(bigrams, forKey: bigramKey)
        if logEnabled { logEvent(k: "CFG", m: "wipe-learned", viewPoint: .zero, frame: nil) }
        buildKeyboard()
        flashBar("Learned words cleared", "")
    }

    @objc private func wordsAddTapped() {
        wordsOpen = false
        addingWord = true
        buildKeyboard()
        showAddWordStrip()
        flashBar("Type the new word", "")
    }

    private func showAddWordStrip() {
        for v in variantStrip.arrangedSubviews {
            variantStrip.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        variantStrip.addArrangedSubview(stripButton("📌 Save word", #selector(addWordSaveTapped)))
        variantStrip.addArrangedSubview(stripButton("✕ Cancel", #selector(addWordCancelTapped)))
        variantStrip.isHidden = false
        panelStrip?.isHidden = true
        heightConstraint.constant = kbBaseHeight + 47
    }

    @objc private func addWordSaveTapped() {
        let w = localWord
        guard w.count >= 2 else {
            flashBar("Type the word first", "")
            return
        }
        personal.insert(w)
        wordStore.set(Array(personal), forKey: personalKey)
        for _ in w { textDocumentProxy.deleteBackward() }
        localWord = ""
        if logEnabled { logEvent(k: "CFG", m: "word-add", viewPoint: .zero, frame: nil) }
        hideVariants()
        // Back into the words editor so he sees the save landed.
        wordsOpen = true
        wordsPage = max(0, (personal.count - 1) / 18)
        buildKeyboard()
        flashBar("Saved: \(w)", "")
    }

    @objc private func addWordCancelTapped() {
        hideVariants()
        wordsOpen = true
        buildKeyboard()
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
            flashBar("Log empty", "")
        } else {
            UIPasteboard.general.string = text
            flashBar("✓ Log copied", "\(logCount) touches")
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
        flashBar("🗑 Log erased", "")
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
        guard slideOn else { return }   // v0.6: Brian's A/B switch (panel)
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
        lastCompletedWord = nil   // v0.6: a new line starts a new phrase
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
