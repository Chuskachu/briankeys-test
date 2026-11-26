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
    /// v0.23: glide typing needs the lift moment (the guess lands then).
    var onSlideEnd: (() -> Void)?
    /// v0.25: glide v3 scores the trace's GEOMETRY — the raw points.
    var onGlidePoint: ((CGPoint) -> Void)?
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
        if let gp = onGlidePoint, let t = touches.first {
            gp(t.location(in: nil))
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        onSlideEnd?()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        onSlideEnd?()
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
    private let hapticMedium = UIImpactFeedbackGenerator(style: .medium)
    private let hapticLight = UIImpactFeedbackGenerator(style: .light)
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
    /// v0.23: slide mode — 0 = off, 1 = letters (the classic drag-typing),
    /// 2 = words (glide typing: trace the path, the guess lands on lift).
    private let slideModeKey = "bk_slide_mode_v1"
    private var slideMode: Int = 1
    private var glidePath: [Character] = []
    private var glideCrossings = 0
    private var glideBaseCount = 0
    private var glideChips: [String]? = nil
    private var glideInserted: String? = nil
    /// v0.25: the trace's raw points (window coords, thinned) — the
    /// geometric scorer measures distance to them, not key order.
    private var glidePoints: [CGPoint] = []
    /// v0.8 (Brian): his words lived in ONE drawer shared between the
    /// app and the keyboard (App Groups). v0.16 (Brian): that drawer
    /// never existed under SideStore — the unsigned build drops the
    /// entitlement (verified 2026-11-14) — so EVERYTHING now lives in
    /// the keyboard's own drawer: wordStore IS .standard. The old
    /// suite is read once at first v0.16 launch to rescue his data
    /// (see rescueWordsFromDeadDrawer).
    static let appGroupID = "group.com.brianklauer.briankeys"
    lazy var wordStore: UserDefaults = .standard
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
        let storedMode = settingInt(slideModeKey, default: -1)
        slideMode = storedMode >= 0 ? min(2, max(0, storedMode)) : (slideOn ? 2 : 0)
        slideOn = slideMode != 0
        keyRowH = CGFloat(min(66, max(46, settingInt(keyHKey, default: 56))))
        keyGap = CGFloat(min(6, max(0, settingInt(keyGapKey, default: 0))))
        bordersOn = settingBool(bordersKey, default: true)
        enterKeyOn = settingBool(enterKeyKey, default: false)
        dismissMode = min(3, max(0, settingInt(dismissKey, default: 0)))
        keyFont = CGFloat(min(30, max(18, settingInt(fontKey, default: 22))))
        themeName = wordStore.string(forKey: themeKey)
            ?? UserDefaults.standard.string(forKey: themeKey) ?? "auto"
        spaceHaptic = min(2, max(0, settingInt(hapticKey, default: 2)))
        chipFont = CGFloat(min(24, max(13, settingInt(chipFontKey, default: 17))))
    }
    /// v0.6 (Brian): personal dictionary — words he pins himself
    /// (long-press a suggestion chip). They outrank learned words.
    private let personalKey = "bk_personal_v1"
    private lazy var personal: Set<String> = Set(wordStore.stringArray(forKey: personalKey) ?? [])
    private var wordsPage = 0
    /// v0.6 (Brian): next-word prediction from HIS phrases — counts of
    /// (previous word → next word), learned when a word is completed.
    private let bigramKey = "bk_bigrams_v1"
    private lazy var bigrams: [String: [String: Int]] = {
        let raw = wordStore.dictionary(forKey: bigramKey) as? [String: [String: Int]] ?? [:]
        // v0.37i purge: pairs learned automatically under the old
        // rules go out with them — a pair survives only when BOTH
        // words are known (dictionary, seed, or saved by him).
        var out: [String: [String: Int]] = [:]
        for (prev, followers) in raw where isKnownWord(prev) {
            let kept = followers.filter { isKnownWord($0.key) }
            if !kept.isEmpty { out[prev] = kept }
        }
        return out
    }()
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
    private let enterKeyKey = "bk_enter_v1"   // v0.26: optional ⏎ key
    private var enterKeyOn = false
    private let dismissKey = "bk_dismiss_v1"   // v0.32: 0 Flick, 1 Button, 2 Both, 3 Off
    private var dismissMode = 0
    private let fontKey = "bk_font_v1"
    private let themeKey = "bk_theme_v1"
    private let hapticKey = "bk_haptic_v1"
    private let chipFontKey = "bk_chipfont_v1"
    private var keyRowH: CGFloat = 56
    private var keyGap: CGFloat = 0
    private var bordersOn: Bool = true
    // v0.18 customization (Brian's picks): letter size, colour theme,
    // space-bar haptic strength.
    private var keyFont: CGFloat = 22
    private var themeName: String = "auto"   // auto | light | dark | contrast
    private var spaceHaptic: Int = 2         // 0 soft, 1 medium, 2 strong
    private var chipFont: CGFloat = 17       // v0.19: suggestion-chip text size
    private var editorOpen = false
    // Staged editor values: nothing persists until he taps Listo.
    private var edPrudent = false, edPopup = true, edSugg = true
    private var edSlideMode = 2
    private var edH: CGFloat = 56, edGap: CGFloat = 0, edBorders = true
    private var edFont: CGFloat = 22, edTheme = "auto", edHaptic = 2
    private var edEnter = false   // v0.26: staged Enter-key option
    private var edDismiss = 0   // v0.32: staged Hide choice
    private var edLang = "es"   // v0.21: es | en | bi
    private var edChipFont: CGFloat = 17
    /// v0.12 (Brian): the big words editor — a full page like the
    /// visual editor, for his OWN words only (the old 5-per-page panel
    /// mixed ~750 learned words in and was useless for managing them).
    private var wordsOpen = false
    private var addingWord = false
    private var editorPreview: UIStackView?
    private var editorHLabel: UILabel?
    private var editorGapLabel: UILabel?
    private var editorFontLabel: UILabel?
    private var editorChipFontLabel: UILabel?
    /// Total keyboard height at the current key size/gaps, anchored on
    /// the known-good 315 at 56pt rows with zero gap.
    // v0.19: +34 — the suggestion bar is now TWO rows (78pt, was 44).
    private var kbBaseHeight: CGFloat { 373 + (keyRowH - 56) * 4 + keyGap * 3 }
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
    /// v0.30i: letters of the word AFTER the cursor, refreshed by
    /// updateSuggestions — non-empty only when Brian went back INTO
    /// a word to fix it.
    private var editSuffix: String = ""

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
    // v0.19: iOS's own spell checker, consulted for its guesses (see
    // computeSuggestions). Cached per word — it talks to the system
    // lexicon service, so we never ask twice for the same word.
    private let textChecker = UITextChecker()
    private var checkerCacheWord = ""
    private var checkerCache: [String] = []

    /// His own words — in no dictionary, top priority (design phase 3
    /// seeds; the in-app manager comes later).
    private let seedWords = ["chumaleeee", "wokiii", "tamos", "contat",
                             "cheverazo", "monasho", "Naná", "Rocío", "Leo",
                             "pelucha", "Pelusa", "kakachon"]
    private let learnedKey = "bk_learned_v1"
    private lazy var learned: [String: Int] = {
        let raw = wordStore.dictionary(forKey: learnedKey) as? [String: Int] ?? [:]
        // v0.37i purge (Brian): automatic learning is gone, and
        // what it had stored goes with it. A word no dictionary
        // knows may live ONLY in My Words, put there by his tap —
        // so this store keeps nothing but dictionary words (in
        // practice it empties: since v0.34i it held only the
        // auto-learned ones, Chichibu and friends included).
        return raw.filter { (w, _) in
            foldedESSet.contains(fold(w)) || foldedENSet.contains(fold(w))
        }
    }()
    /// Accent-folded forms of the learned words, cached (v0.2 diet).
    private var learnedFolded: [String: String] = [:]
    // (v0.34i's pending-graduation set died in v0.37i, with the
    // automatic learning it served.)

    // MARK: - Autocorrector (v0.33i — the standard rebuild)
    //
    // Brian's call (2026-11-24): suggestions and autocorrection are
    // NOT where MyKeys should be original — every market keyboard
    // does them well, so MyKeys takes the STANDARD model (AOSP's
    // cost list, ONE engine for chips and corrections, big
    // dictionaries, an undo chip after every fix) and spends its
    // originality on customisation instead. The old V1.8 "prudent"
    // judge — a separate engine with its own distance function and
    // a tiny candidate pool — was deleted whole; autoFix holds the
    // rules that replaced it. The switch (Editor -> Corrector) and
    // its pref key keep their V1.8 names so his setting survives.
    private let prudentKey = "bk_prudent_v1"
    private lazy var prudentEnabled: Bool = settingBool(prudentKey, default: false)
    // v0.33i: after the corrector changes a word, his original stays
    // on offer as the first chip (in quotes, like iOS) until he
    // starts the next word; reverting blacklists the word forever.
    private var pendingUndo: (original: String, corrected: String)?
    private let noCorrectKey = "bk_nocorrect_v1"
    private lazy var noCorrect: Set<String> = Set(wordStore.stringArray(forKey: noCorrectKey) ?? [])
    private var undoOffer: (original: String, corrected: String)? {
        guard let u = pendingUndo, localWord.isEmpty, editSuffix.isEmpty,
              (textDocumentProxy.documentContextBeforeInput ?? "").hasSuffix(u.corrected + " ")
        else { return nil }
        return u
    }
    private lazy var foldedESSet: Set<String> = Set(foldedES)
    private lazy var foldedENSet: Set<String> = Set(foldedEN)
    private lazy var foldedES: [String] = WordLists.es.map { fold($0) }
    private lazy var foldedEN: [String] = WordLists.en.map { fold($0) }
    private lazy var foldedSeeds: [String] = seedWords.map { fold($0) }

    private func fold(_ s: String) -> String {
        s.lowercased().folding(options: .diacriticInsensitive, locale: nil)
    }

    /// v0.16 (Brian): the shared drawer is dead (see wordStore). On
    /// the first v0.16 launch, rescue EVERYTHING the keyboard kept in
    /// the old suite — his words, counts, language, switches, geometry
    /// and emoji tallies — into the keyboard's own drawer. A key is
    /// copied only when the local drawer does not have it yet, so the
    /// rescue can never overwrite anything newer.
    private func rescueWordsFromDeadDrawer() {
        let local = UserDefaults.standard
        guard local.object(forKey: "bk_local_home_v16") == nil,
              let dead = UserDefaults(suiteName: KeyboardViewController.appGroupID)
        else { return }
        let keys = [personalKey, learnedKey, bigramKey, langKey,
                    prudentKey, popupKey, suggKey, slidePrefKey,
                    keyHKey, keyGapKey, bordersKey, logOnKey,
                    "bk_emoji_counts_v1", "bk_emoji_recents_v1"]
        for k in keys {
            if local.object(forKey: k) == nil, let v = dead.object(forKey: k) {
                local.set(v, forKey: k)
            }
        }
        local.set(true, forKey: "bk_local_home_v16")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        rescueWordsFromDeadDrawer()   // v0.16: before anything reads his words
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
        applyTrayColor()
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
        // v0.19 (Brian): TWO thinner rows of chips instead of one —
        // 6 suggestions instead of 3, so pairs like grabo/grabó fit.
        // v0.34i (Brian): THREE rows of 30pt — 9 chips, so the
        // relevant options stop being cut for lack of room.
        suggestionBar.axis = .vertical
        suggestionBar.distribution = .fill
        suggestionBar.spacing = 6
        suggestionBar.heightAnchor.constraint(equalToConstant: 102).isActive = true
        let chipRows: [UIStackView] = (0..<3).map { _ in
            let r = UIStackView()
            r.axis = .horizontal
            r.distribution = .fillEqually
            r.spacing = 6
            r.heightAnchor.constraint(equalToConstant: 30).isActive = true
            suggestionBar.addArrangedSubview(r)
            return r
        }
        chips = (0..<9).map { i in
            let c = UIButton(type: .system)
            c.titleLabel?.font = .systemFont(ofSize: chipFont, weight: .medium)
            c.setTitleColor(keyTitleColor, for: .normal)
            c.backgroundColor = keyColor
            c.layer.cornerRadius = 8
            c.tag = i
            c.addTarget(self, action: #selector(chipTapped(_:)), for: .touchUpInside)
            // v0.6: long-press a chip = pin that word as HIS (personal
            // dictionary, top priority in future suggestions).
            let chipLP = UILongPressGestureRecognizer(target: self, action: #selector(chipLongPressed(_:)))
            chipLP.minimumPressDuration = 0.45
            c.addGestureRecognizer(chipLP)
            chipRows[i / 3].addArrangedSubview(c)
            return c
        }

        buildKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshSettings()   // v0.9: pick up switches he flipped in the app
        applyAppAppearance()   // v0.17: match the app's requested look
        applyTrayColor()   // v0.18: themeName is fresh from refreshSettings now
        // v0.18: cached pages keep the colours of whenever they were
        // built. If the light/dark flip happened while the keyboard was
        // closed, traitCollectionDidChange never fires and a cached page
        // (Brian saw the numbers page stay WHITE in a dark app) keeps the
        // old look. Rebuilding once per open keeps pages consistent;
        // the cache still serves switches within the session.
        pageCache.removeAll()
        suppressNextCacheSave = true   // v0.22: detachAll would re-save it
        // v0.19: the LETTERS page is baked once in viewDidLoad — before
        // applyAppAppearance ever reads the app's declared look — and no
        // path repainted it afterwards, so it kept the phone's style
        // while pages built later (numbers) followed the app. That is
        // Brian's "dark in letters, light in numbers" in BOTH v0.17 and
        // v0.18. Repaint the visible page now that the look is settled.
        // v0.30i (Brian, 2026-11-23): swipe DOWN to put the keyboard
        // away — he sometimes opens it by tapping a text box by
        // accident and it eats half the screen. The pan must START
        // above the bottom row (space lives there: flick = Enter,
        // long-press = trackpad) and travel mostly straight down.
        // cancelsTouchesInView = false, so typing and slide are
        // never stolen. The hide itself is
        // UIInputViewController.dismissKeyboard() — the first
        // v0.30i build FAILED because UIApplication.shared is
        // NS_EXTENSION_UNAVAILABLE inside extensions.
        let dismissPan = UIPanGestureRecognizer(target: self, action: #selector(dismissPanMoved(_:)))
        dismissPan.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissPan)
        // buildKeyboardNow, NOT buildKeyboard: the snapshot cover is
        // pointless (and possibly a blank flash) before first layout.
        buildKeyboardNow()
    }

    /// v0.17 (Brian): first the app, then iOS — like Apple's keyboard.
    /// The app declares the appearance it wants on its text field and
    /// the proxy carries it here; a third-party keyboard has to READ
    /// it and re-skin itself (MyKeys never did, so it fell back to the
    /// phone's own mode and clashed with light-locked apps). When the
    /// app declares nothing (.default), follow the phone as before.
    /// Changing the override fires traitCollectionDidChange, which
    /// already rebuilds with fresh colours.
    /// v0.20 HYPOTHESIS (Brian verifies): the style applyAppAppearance
    /// decided on, kept so solidImage can bake the key colours with
    /// THIS style explicitly. The ambient traitCollection still lags
    /// one beat behind the override when viewWillAppear rebuilds —
    /// v0.19's miss: dynamic chips rendered light while the baked
    /// keys stayed dark, in the same screenshot.
    private var effectiveStyle: UIUserInterfaceStyle = .unspecified

    private func applyAppAppearance() {
        let want: UIUserInterfaceStyle
        // v0.18: a theme Brian picked himself beats the app's request.
        switch themeName {
        case "light": want = .light
        case "dark", "contrast": want = .dark
        default:
            switch textDocumentProxy.keyboardAppearance {
            case .dark: want = .dark
            case .light: want = .light
            default: want = .unspecified
            }
        }
        effectiveStyle = want
        if overrideUserInterfaceStyle != want {
            overrideUserInterfaceStyle = want
        }
    }

    /// v0.18: the tray behind the keys — black on the contrast theme,
    /// the usual iPhone tray grey otherwise.
    private func applyTrayColor() {
        if themeName == "contrast" {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = UIColor { traits in
                traits.userInterfaceStyle == .dark
                    ? UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1)
                    : UIColor(red: 0.82, green: 0.83, blue: 0.86, alpha: 1)
            }
        }
    }

    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        applyAppAppearance()   // v0.17: the field (and its look) can change under us
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

    /// v0.19 (Brian): he taps back into an earlier word to fix it and
    /// the bar showed nothing for it — cursor MOVES fire this callback,
    /// not textDidChange, and we never implemented it. Adopt the word
    /// under the cursor exactly like an outside text change.
    override func selectionDidChange(_ textInput: UITextInput?) {
        super.selectionDidChange(textInput)
        let proxyWord = currentWord()
        if proxyWord != localWord {
            localWord = proxyWord
            updateSuggestions()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flushLog()   // v0.2: don't strand buffered log events
        flushStores()   // v0.26: don't strand un-persisted learning
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
        // v0.14 flash attempt #2 (HYPOTHESIS — v0.13's transaction did
        // not kill the flash): cover the swap with a snapshot of the
        // page as it is now; the rebuilt page is only revealed on the
        // next frame, complete, so no intermediate state can show.
        let cover = view.snapshotView(afterScreenUpdates: false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        UIView.performWithoutAnimation {
            buildKeyboardNow()
            view.layoutIfNeeded()
        }
        CATransaction.commit()
        if let cover = cover {
            cover.frame = view.bounds
            view.addSubview(cover)
            DispatchQueue.main.async { cover.removeFromSuperview() }
        }
    }

    // v0.15 flash attempt #3 (HYPOTHESIS): PERSISTENT PAGES. Each mode
    // page is built once; switching detaches its views into a cache
    // and reattaches them later — no rebuild, like Apple's keyboard.
    // Attempts #1 (no-animation transaction) and #2 (snapshot cover)
    // both failed. The editor pages are never cached (stateful, rare).
    private struct CachedPage {
        var views: [UIView]
        var slideKeys: [KeyButton]
        var letterButtons: [KeyButton]
        var shiftButton: KeyButton?
        var height: CGFloat
    }
    private var pageCache: [Mode: CachedPage] = [:]
    // v0.22: when a rebuild is meant to DROP the cached pages
    // (appearance flip, editor applied), detachAll must not save
    // the visible page straight back into the cache — that silent
    // re-save is why the letters page kept its viewDidLoad colours
    // through v0.19's repaint and v0.20's effectiveStyle bake:
    // the repaint never happened, the dark page was reattached.
    private var suppressNextCacheSave = false
    private var shownModePage: Mode? = nil
    private var emojiStale = false

    /// Empties the stack. If a mode page was showing, its content views
    /// go into the cache ALIVE instead of being destroyed.
    private func detachAll() {
        let arranged = mainStack.arrangedSubviews
        guard !arranged.isEmpty else { return }
        var prefix = (arranged.first === suggestionBar) ? 1 : 0
        prefix += 2   // the variant strip and the panel strip follow
        if arranged.count > prefix, let m = shownModePage, !suppressNextCacheSave {
            let content = Array(arranged[prefix...])
            pageCache[m] = CachedPage(views: content,
                                      slideKeys: slideKeys,
                                      letterButtons: letterButtons,
                                      shiftButton: shiftButton,
                                      height: heightConstraint.constant)
            for v in content {
                mainStack.removeArrangedSubview(v)
                v.removeFromSuperview()
            }
        }
        for v in mainStack.arrangedSubviews {
            mainStack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        shownModePage = nil
        suppressNextCacheSave = false   // v0.22: one-shot
    }

    private func buildKeyboardNow() {
        detachAll()
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
        // v0.14 (Brian): on the emoji page the suggestion bar is
        // useless — its space goes to the two category rows instead.
        if mode != .emoji { mainStack.addArrangedSubview(suggestionBar) }

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
        } else if let cached = pageCache[mode], !(mode == .emoji && emojiStale) {
            // v0.15: reattach the cached page — no rebuild at all.
            slideKeys = cached.slideKeys
            letterButtons = cached.letterButtons
            shiftButton = cached.shiftButton
            for v in cached.views { mainStack.addArrangedSubview(v) }
            heightConstraint.constant = cached.height
            shownModePage = mode
            if mode == .letters { applyShiftVisuals() }
        } else {
            if mode != .emoji { heightConstraint.constant = kbBaseHeight }
            switch mode {
            case .letters: buildLetters()
            case .numbers: buildNumbers()
            case .symbols: buildSymbols()
            case .emoji: buildEmoji(); emojiStale = false
            }
            shownModePage = mode
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
    /// v0.18: on the contrast theme the keys are white/yellow, so their
    /// text stays black even though the traits run dark.
    private var keyTitleColor: UIColor { themeName == "contrast" ? .black : .label }
    private var keyColor: UIColor {
        if themeName == "contrast" { return UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
        return UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.36, green: 0.36, blue: 0.38, alpha: 1)
            : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1) }
    }
    private var functionKeyColor: UIColor {
        if themeName == "contrast" { return UIColor(red: 1.0, green: 0.84, blue: 0.10, alpha: 1) }
        return UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.20, green: 0.20, blue: 0.22, alpha: 1)
            : UIColor(red: 0.66, green: 0.68, blue: 0.72, alpha: 1) }
    }
    // Pressed-state colours: keys visibly react the instant they are
    // touched — part of "responde lento" was that nothing SEEMED to happen.
    private var keyPressedColor: UIColor {
        if themeName == "contrast" { return UIColor(white: 0.80, alpha: 1) }
        return UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.52, green: 0.52, blue: 0.55, alpha: 1)
            : UIColor(red: 0.84, green: 0.85, blue: 0.87, alpha: 1) }
    }
    private var functionPressedColor: UIColor {
        if themeName == "contrast" { return UIColor(red: 0.85, green: 0.68, blue: 0.05, alpha: 1) }
        return UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.30, green: 0.30, blue: 0.32, alpha: 1)
            : UIColor(red: 0.52, green: 0.54, blue: 0.58, alpha: 1) }
    }

    private func solidImage(_ color: UIColor) -> UIImage {
        // v0.3: bake the 1x1 image with the KEYBOARD's own trait
        // collection. The default renderer uses the main screen's traits;
        // when the host app asks the keyboard for the other appearance,
        // the frozen image kept the wrong mode's colour while the labels
        // followed the view — Brian's "se invierte el color" (2026-11-12).
        // v0.20: resolve against the EFFECTIVE style when one is set,
        // so a bake that happens before the override lands on the
        // trait collection still freezes the intended colour.
        let traits = effectiveStyle == .unspecified
            ? traitCollection
            : UITraitCollection(traitsFrom: [traitCollection,
                UITraitCollection(userInterfaceStyle: effectiveStyle)])
        let resolved = color.resolvedColor(with: traits)
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
            pageCache.removeAll()   // v0.15: cached pages hold old colours
            suppressNextCacheSave = true   // v0.22: don't re-save the stale page
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
        b.titleLabel?.font = .systemFont(ofSize: keyFont, weight: .medium)
        b.setTitleColor(keyTitleColor, for: .normal)
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
        b.onSlideEnd = { [weak self] in self?.slideEnded() }
        b.onGlidePoint = { [weak self] pt in self?.recordGlidePoint(pt) }
        slideKeys.append(b)
        if !variants.isEmpty { addLongPress(to: b) }
        return b
    }

    private func functionKey(_ title: String, action: Selector, flex: CGFloat = 1.0) -> KeyButton {
        let b = KeyButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        b.setTitleColor(keyTitleColor, for: .normal)
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
        // v0.18: Brian picks the strength in the editor (Haptic pill).
        switch spaceHaptic {
        case 0:
            hapticLight.impactOccurred(intensity: 0.8)
            hapticLight.prepare()
        case 1:
            hapticMedium.impactOccurred(intensity: 0.9)
            hapticMedium.prepare()
        default:
            hapticHeavy.impactOccurred(intensity: 0.85)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) { [weak self] in
                self?.hapticHeavy.impactOccurred(intensity: 0.55)
                self?.hapticHeavy.prepare()
            }
            hapticHeavy.prepare()
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
        // v0.29i (Brian, 2026-11-20): the yen sign sits next to the
        // dollar on the numbers page too (it also stays on the
        // symbols page, where it already lived).
        mainStack.addArrangedSubview(makeRow(["-", "/", ":", ";", "(", ")", "$", "¥", "&", "@", "\""].map { punctKey($0) }))
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
    // v0.14: sections — 0 = ⭐ Top (most used, then recent), 1...9 =
    // EmojiData.categories. Usage is tracked locally per emoji tap.
    private var emojiSection = 0
    private var emojiCounts: [String: Int] = [:]
    private var emojiRecents: [String] = []
    private var emojiUseLoaded = false

    private func ensureEmojiUse() {
        if emojiUseLoaded { return }
        emojiUseLoaded = true
        emojiCounts = wordStore.dictionary(forKey: "bk_emoji_counts_v1") as? [String: Int] ?? [:]
        emojiRecents = wordStore.array(forKey: "bk_emoji_recents_v1") as? [String] ?? []
    }

    private func recordEmojiUse(_ e: String) {
        ensureEmojiUse()
        emojiCounts[e, default: 0] += 1
        emojiRecents.removeAll { $0 == e }
        emojiRecents.insert(e, at: 0)
        if emojiRecents.count > 96 { emojiRecents = Array(emojiRecents.prefix(96)) }
        wordStore.set(emojiCounts, forKey: "bk_emoji_counts_v1")
        wordStore.set(emojiRecents, forKey: "bk_emoji_recents_v1")
        emojiStale = true   // v0.15: the cached ⭐ Top must rebuild
        topEmojisCache = nil   // v0.26: the slot's cache too
    }

    /// ⭐ Top (Brian's order): most used first, then recently used
    /// ones that are not already in the most-used list.
    private var topEmojisCache: [String]? = nil   // v0.26 audit fix
    private func topEmojis() -> [String] {
        if let c = topEmojisCache { return c }
        ensureEmojiUse()
        let most = emojiCounts.sorted { a, b in
            if a.value != b.value { return a.value > b.value }
            return (emojiRecents.firstIndex(of: a.key) ?? 999) < (emojiRecents.firstIndex(of: b.key) ?? 999)
        }.prefix(64).map { $0.key }
        let mostSet = Set(most)
        let rest = emojiRecents.filter { !mostSet.contains($0) }
        var combined = Array((most + rest).prefix(96))
        // v0.15 (Brian's screenshot): Top looked empty with only 2 of
        // his own — pad with starters until he has a full page (32).
        if combined.count < 32 {
            let starters = ["😀", "😂", "😍", "😎", "🤔", "👍", "❤️", "🔥", "🙏", "🎉", "😅", "🤓", "😊", "🥹", "😴", "🤯",
                            "👋", "🙂", "😉", "🤣", "😭", "😱", "🥰", "😋", "🙄", "💪", "🎂", "⚽", "🚗", "🐶", "🍔", "😴"]
            var seen = Set(combined)
            for st in starters where !seen.contains(st) {
                if combined.count >= 32 { break }
                seen.insert(st)
                combined.append(st)
            }
            topEmojisCache = combined
            return combined
        }
        if !combined.isEmpty { topEmojisCache = combined; return combined }
        return ["😀", "😂", "😍", "😎", "🤔", "👍", "❤️", "🔥", "🙏", "🎉", "😅", "🤓", "😊", "🥹", "😴", "🤯"]
    }

    private func emojiItems() -> [String] {
        if emojiSection == 0 { return topEmojis() }
        let cats = EmojiData.categories
        let i = min(max(0, emojiSection - 1), cats.count - 1)
        let start = cats[i].start
        let end = i + 1 < cats.count ? cats[i + 1].start : EmojiData.all.count
        return Array(EmojiData.all[start..<end])
    }

    private func buildEmoji() {
        // v0.14 (Brian): TWO rows of big category buttons where the
        // suggestion bar used to be — ⭐ Top first (most used, then
        // recent), then the 9 Unicode categories. 32 emojis per page.
        let items = emojiItems()
        let perPage = 32
        let pages = max(1, (items.count + perPage - 1) / perPage)
        emojiPage = min(max(0, emojiPage), pages - 1)

        let catDefs: [(String, String)] = [("⭐", "Top")] + EmojiData.categories.map { ($0.icon, $0.label) }
        for rowIdx in 0..<2 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = keyGap
            row.heightAnchor.constraint(equalToConstant: 36).isActive = true
            for i in (rowIdx * 5)..<min(rowIdx * 5 + 5, catDefs.count) {
                let b = UIButton(type: .system)
                b.setTitle("\(catDefs[i].0) \(catDefs[i].1)", for: .normal)
                b.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
                b.setTitleColor(keyTitleColor, for: .normal)
                b.backgroundColor = i == emojiSection ? UIColor.systemOrange.withAlphaComponent(0.35) : keyColor
                b.layer.cornerRadius = 8
                outline(b)
                b.tag = i
                b.addTarget(self, action: #selector(emojiCategoryTapped(_:)), for: .touchUpInside)
                row.addArrangedSubview(b)
            }
            mainStack.addArrangedSubview(row)
        }

        let slice = Array(items.dropFirst(emojiPage * perPage).prefix(perPage))
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
        // v0.35i (Brian): search emojis by name, right here.
        let searchBtn = functionKey("🔍", action: #selector(emojiSearchTapped))
        searchBtn.widthAnchor.constraint(equalToConstant: 64).isActive = true
        row.addArrangedSubview(searchBtn)
        let space = KeyButton(type: .system)
        space.setTitle("space", for: .normal)
        space.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        space.setTitleColor(keyTitleColor, for: .normal)
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

        // Two category rows + pager make this page taller than letters
        // (and the suggestion bar is hidden here, which buys some back).
        heightConstraint.constant = kbBaseHeight + 84
    }

    @objc private func emojiCategoryTapped(_ sender: UIButton) {
        emojiSection = sender.tag
        emojiPage = 0
        // v0.18: without this, the v0.15 page cache reattaches the OLD
        // emoji page and the tap looks dead — category and page taps
        // must force a fresh buildEmoji, same as recordEmojiUse does.
        emojiStale = true
        buildKeyboard()
    }

    @objc private func emojiPrevTapped() {
        if emojiPage > 0 { emojiPage -= 1 }
        emojiStale = true   // v0.18: beat the page cache, see emojiCategoryTapped
        buildKeyboard()
    }

    @objc private func emojiNextTapped() {
        let pages = max(1, (emojiItems().count + 31) / 32)
        if emojiPage < pages - 1 { emojiPage += 1 }
        emojiStale = true   // v0.18: beat the page cache, see emojiCategoryTapped
        buildKeyboard()
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
        recordEmojiUse(e)
        updateSuggestions()
        // Stay on the emoji page: Brian may want two or three in a row.
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
        space.setTitleColor(keyTitleColor, for: .normal)
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
        //
        // v0.26 (Brian): …and now it can COME BACK, as HIS choice —
        // Editor → Enter. The space bar yields its right end to a ⏎
        // key and returns to a normal width; the flick keeps working.
        // v0.32i (Brian): the hide-the-keyboard BUTTON — his choice
        // in Editor -> Hide (Flick / Button / Both / Off), because
        // MyKeys' promise is the most customisable keyboard there
        // is. Small, at the space bar's right, and deliberately
        // NOTHING like ⏎: a keyboard glyph with a down chevron.
        // The Enter key, when on, keeps the right edge.
        if dismissMode == 1 || dismissMode == 2 {
            let hide = functionKey("⌨\u{FE0E}⌄", action: #selector(dismissButtonTapped))
            hide.titleLabel?.font = .systemFont(ofSize: 20)
            hide.widthAnchor.constraint(equalToConstant: 42).isActive = true
            row.addArrangedSubview(hide)
        }
        if enterKeyOn {
            let enter = functionKey("⏎", action: #selector(returnTapped))
            enter.widthAnchor.constraint(equalToConstant: 54).isActive = true
            row.addArrangedSubview(enter)
        }

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

    /// v0.30i: letters of the same word AFTER the cursor (empty when
    /// the cursor sits at the word's end, the normal typing case).
    private func wordSuffix() -> String {
        let after = textDocumentProxy.documentContextAfterInput ?? ""
        var word = ""
        for ch in after {
            if ch.isLetter { word.append(ch) } else { break }
        }
        return word
    }

    /// v0.30i (Brian): a suggestion wears the case of what he TYPED.
    /// After a period he starts with a capital, so "Manana" must
    /// offer "Mañana", not "mañana". His rule: grammar rules, NOT a
    /// second capitalised dictionary. ALL-CAPS typing -> ALL-CAPS
    /// offers.
    private func typedCaseForm(_ w: String) -> String {
        let t = localWord
        guard let f = t.first, f.isUppercase else { return w }
        if t.count >= 2 && t == t.uppercased() { return w.uppercased() }
        return w.prefix(1).uppercased() + w.dropFirst()
    }

    /// Count a word so the bar learns Brian's vocabulary.
    // v0.26 audit fix: learned/bigram stores used to serialize in
    // full on EVERY completed word. Now: mark dirty, flush at most
    // every 5 s and when the keyboard disappears.
    private var storeDirty = false
    private var lastStoreFlush = Date.distantPast
    private func markStoreDirty() {
        storeDirty = true
        if Date().timeIntervalSince(lastStoreFlush) > 5 { flushStores() }
    }
    private func flushStores() {
        guard storeDirty else { return }
        storeDirty = false
        lastStoreFlush = Date()
        wordStore.set(learned, forKey: learnedKey)
        wordStore.set(bigrams, forKey: bigramKey)
    }

    private func learn(_ w: String) {
        // v0.37i (Brian): automatic word learning is GONE. Until
        // now the keyboard quietly stored words no dictionary
        // knows once it had seen them twice — and a typo repeated
        // a few times looks exactly like a new word, so junk
        // could settle in as if it were his. His rule from here:
        // a word the dictionaries do not know enters ONLY
        // through his deliberate tap on its quoted chip, into
        // My Words; dictionary words need no learning, the
        // dictionary already has them. This hook stays for the
        // call sites and intentionally stores nothing.
    }

    /// v0.37i: a word the keyboard may remember on its own —
    /// it is in a dictionary, in the seeds, or in My Words
    /// because HE put it there.
    private func isKnownWord(_ w: String) -> Bool {
        let f = fold(w)
        return foldedESSet.contains(f) || foldedENSet.contains(f)
            || foldedSeeds.contains(f)
            || personal.contains(where: { fold($0) == f })
    }

    /// A word was just completed (space / punctuation / return): first
    /// let the prudent corrector judge it, then learn the FINAL form —
    /// a corrected word reinforces its correction, and the raw typo is
    /// never learned.
    private func completeWord() {
        let w = localWord
        guard w.count >= 2 else { return }
        var final = w
        if prudentEnabled, let fixed = autoFix(for: w) {
            replaceCurrentWord(with: fixed)
            final = fixed
            pendingUndo = (original: w, corrected: fixed)
            // (v0.2: the corrector's old double-tick haptic is gone —
            // haptics are space-only now. The corrector is parked anyway.)
        }
        learn(final)
        noteCompleted(final)   // v0.6: feed the bigram counts
    }

    /// v0.33i (Brian's standard rebuild): the autocorrect judge,
    /// written from zero on the AOSP model — the SAME price list
    /// and frequency scores the suggestion chips use. Rules:
    /// 1. A word that EXISTS is never touched: both dictionaries
    ///    (30k words each since v0.33i), his seeds, his pinned
    ///    words, anything he has completed twice.
    /// 2. A word he once reverted via the undo chip is never
    ///    touched again.
    /// 3. The fix must be exactly ONE edit away, must not merely
    ///    extend what he typed (completions are the chips' job),
    ///    and must WIN CLEARLY — a runner-up within 6 points
    ///    means the keyboard keeps its hands off.
    /// 4. A learned word may only supply a fix when a dictionary
    ///    backs it or he uses it a lot (5+) — trusting a stray
    ///    learned word is how the old engine turned his "ícono"
    ///    into "cono" (the 10k list did not even contain "icono",
    ///    so a real word was judged a typo).
    private func autoFix(for w: String) -> String? {
        guard w.count >= 4 else { return nil }
        // All-caps words are acronyms and intentions, not typos.
        if w == w.uppercased() { return nil }
        let fw = fold(w)
        if foldedESSet.contains(fw) || foldedENSet.contains(fw) { return nil }
        if foldedSeeds.contains(fw) { return nil }
        if personal.contains(where: { fold($0) == fw }) { return nil }
        for (surface, count) in learned where count >= 2 && fold(surface) == fw { return nil }
        if noCorrect.contains(fw) { return nil }
        var scored: [(word: String, score: Double)] = []
        func consider(_ surface: String, _ base: Double) {
            let cf = fold(surface)
            guard cf != fw, !cf.hasPrefix(fw),
                  let cost = editCostOne(fw, cf) else { return }
            scored.append((surface, base - cost))
        }
        for seed in seedWords { consider(seed, 95) }
        for p in personal { consider(p, 90) }
        for (surface, count) in learned {
            let sf = fold(surface)
            let backed = foldedESSet.contains(sf) || foldedENSet.contains(sf)
            guard backed || count >= 5 else { continue }
            consider(surface, 55 + min(25, Double(2 * count)))
        }
        let lists: [[String]] = lang == "en" ? [WordLists.en]
            : lang == "bi" ? [WordLists.es, WordLists.en]
            : [WordLists.es]
        for list in lists {
            for (rank, word) in list.prefix(6000).enumerated() {
                consider(word, 40.0 * (1.0 - Double(rank) / Double(list.count)))
            }
        }
        guard let best = scored.max(by: { $0.score < $1.score }) else { return nil }
        let runnerUp = scored.filter { fold($0.word) != fold(best.word) }.map { $0.score }.max() ?? -1000
        guard best.score - runnerUp >= 6 else { return nil }
        var fixed = best.word
        // Keep his capitalisation.
        if let first = w.first, first.isUppercase {
            fixed = fixed.prefix(1).uppercased() + fixed.dropFirst()
        }
        return fixed
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
    /// v0.27i: the AOSP price list for ONE edit, in pool points.
    /// Substitution is cheapest — and HALF price when the wrong
    /// letter is a physical neighbour of the right one (a graze).
    /// Then omission, transposition, insertion. nil = not one edit.
    private func editCostOne(_ a: String, _ b: String) -> Double? {
        let x = Array(a), y = Array(b)
        if abs(x.count - y.count) > 1 { return nil }
        if x.count == y.count {
            var diffs: [Int] = []
            for i in x.indices where x[i] != y[i] { diffs.append(i) }
            if diffs.count == 1 {
                let i = diffs[0]
                return (keyNeighbours[x[i]]?.contains(y[i]) ?? false) ? 2.0 : 3.8
            }
            if diffs.count == 2 {
                let i = diffs[0], j = diffs[1]
                if j == i + 1 && x[i] == y[j] && x[j] == y[i] { return 5.6 }
            }
            return nil
        }
        let (short, long) = x.count < y.count ? (x, y) : (y, x)
        var i = 0, j = 0, skipped = false
        while i < short.count {
            if short[i] == long[j] {
                i += 1; j += 1
            } else {
                if skipped { return nil }
                skipped = true
                j += 1
            }
        }
        return x.count < y.count ? 4.7 : 7.2   // a is the typed text
    }

    /// v0.26 (AOSP audit): physical key neighbours, from the actual
    /// rows — a graze substitution (i for o) should outrank a far-key
    /// substitution of a slightly more frequent word.
    private let keyNeighbours: [Character: Set<Character>] = {
        let rows = ["qwertyuiop", "asdfghjklñ", "zxcvbnm"].map { Array($0) }
        var map: [Character: Set<Character>] = [:]
        for (r, row) in rows.enumerated() {
            for (i, ch) in row.enumerated() {
                var set: Set<Character> = []
                for dr in -1...1 {
                    let rr = r + dr
                    guard rr >= 0, rr < rows.count else { continue }
                    for di in -1...1 where !(dr == 0 && di == 0) {
                        let ii = i + di
                        if ii >= 0, ii < rows[rr].count { set.insert(rows[rr][ii]) }
                    }
                }
                map[ch] = set
            }
        }
        return map
    }()

    private func computeSuggestions(for prefix: String) -> [String] {
        if prefix.isEmpty {
            // No word in progress: v0.6 — first, what HIS phrases say
            // comes next (bigrams); then his most-used learned words.
            var out: [String] = []
            if let prev = lastCompletedWord?.lowercased(),
               let followers = bigrams[prev] {
                out += followers.sorted { $0.value > $1.value }.prefix(3).map { $0.key }
            }
            if out.count < 8 {
                for w in learned.sorted { $0.value > $1.value } where !out.contains(w.key) {
                    out.append(w.key)
                    if out.count == 8 { break }
                }
            }
            return out
        }
        let fp = fold(prefix)
        // v0.27i (Brian — "no con calma", 2026-11-19): the UNIFIED
        // SCORER, AOSP style. Every candidate goes into ONE pool and
        // is priced the same way: frequency, minus the cost of the
        // evidence against it (letters still to complete; one edit
        // from editCostOne's price list), plus a bonus when the word
        // follows his previous word in his own phrases. Pass ORDER
        // no longer decides the chips — a frequent word one graze
        // away can finally beat a rare exact-prefix word.
        var pool: [String: (word: String, score: Double, seq: Int)] = [:]
        var poolSeq = 0
        func accented(_ s: String) -> Bool {
            s.folding(options: .diacriticInsensitive, locale: nil) != s
        }
        func addToPool(_ surface: String, _ score: Double) {
            let f = fold(surface)
            if let cur = pool[f] {
                if score > cur.score + 0.01 {
                    pool[f] = (surface, score, cur.seq)
                } else if score > cur.score - 0.01,
                          !accented(cur.word), accented(surface) {
                    // v0.9's rule survives: the accented twin wins.
                    pool[f] = (surface, max(score, cur.score), cur.seq)
                }
                return
            }
            pool[f] = (surface, score, poolSeq)
            poolSeq += 1
        }
        func freqScore(_ rank: Int, _ total: Int) -> Double {
            40.0 * (1.0 - Double(rank) / Double(max(1, total)))
        }
        let prevFollowers = lastCompletedWord.flatMap { bigrams[$0.lowercased()] }
        func contextBonus(_ surface: String) -> Double {
            guard let fol = prevFollowers,
                  let c = fol[surface] ?? fol[surface.lowercased()] else { return 0 }
            return min(15.0, Double(c) * 3.0)
        }
        for (i, seed) in seedWords.enumerated() where foldedSeeds[i].hasPrefix(fp) {
            addToPool(seed, 95 + contextBonus(seed))
        }
        // v0.6: his pinned personal words outrank merely-learned ones.
        for w in personal.sorted { (learned[$0] ?? 0) > (learned[$1] ?? 0) }
        where fold(w).hasPrefix(fp) {
            addToPool(w, 90 + contextBonus(w))
        }
        let learnedMatches = learned
            .filter { (learnedFolded[$0.key] ?? fold($0.key)).hasPrefix(fp) }
            .sorted { $0.value > $1.value }
        for m in learnedMatches {
            addToPool(m.key, 55 + min(25.0, Double(m.value) * 2.0) + contextBonus(m.key))
        }
        // Completions, priced per letter still missing (AOSP: the
        // first completed letter is the expensive one). An EXACT
        // folded match — he typed the word itself — gets promoted.
        let dictWords = lang == "en" ? WordLists.en : WordLists.es
        let dictFolded = lang == "en" ? foldedEN : foldedES
        func addCompletions(_ words: [String], _ folded: [String]) {
            var added = 0
            for (i, w) in words.enumerated() where folded[i].hasPrefix(fp) {
                let extra = folded[i].count - fp.count
                var s = freqScore(i, words.count) + contextBonus(w)
                if extra == 0 { s += 12 }
                else { s -= 4.8 + 0.1 * Double(extra - 1) }
                addToPool(w, s)
                added += 1
                if added >= 80 { break }
            }
        }
        addCompletions(dictWords, dictFolded)
        if lang == "bi" { addCompletions(WordLists.en, foldedEN) }
        // v0.19's tilde twin, now priced into the pool (plain first).
        if lang != "en", prefix.count >= 4,
           let last = prefix.lowercased().last,
           "aeiou".contains(last) {
            let longerExists = dictFolded.contains {
                $0.count > fp.count && $0.hasPrefix(fp)
            }
            if !longerExists {
                let accents: [Character: Character] = ["a": "á", "e": "é", "i": "í", "o": "ó", "u": "ú"]
                let lower = prefix.lowercased()
                var twin: String? = nil
                if lower.hasSuffix("ia") {
                    twin = String(lower.dropLast(2)) + "ía"
                } else if lower.hasSuffix("io") {
                    twin = String(lower.dropLast(2)) + "ío"
                } else if let a = accents[last] {
                    twin = String(lower.dropLast()) + String(a)
                }
                if let twin, twin != lower {
                    addToPool(lower, 62 + contextBonus(lower))
                    addToPool(twin, 61.5 + contextBonus(twin))
                }
            }
        }
        // v0.19: iOS's own spell checker, priced in like everyone else.
        if prefix.count >= 3 {
            if checkerCacheWord != prefix {
                checkerCacheWord = prefix
                let ns = prefix as NSString
                checkerCache = textChecker.guesses(
                    forWordRange: NSRange(location: 0, length: ns.length),
                    in: prefix,
                    language: lang == "en" ? "en" : "es") ?? []
            }
            for g in checkerCache where g != prefix {
                addToPool(g, 34 + contextBonus(g))
            }
        }
        // Near-words (v0.12), priced by editCostOne instead of order.
        if prefix.count >= 3 {
            for (i, w) in dictWords.enumerated().prefix(4000)
            where !dictFolded[i].hasPrefix(fp) {
                if let cost = editCostOne(fp, dictFolded[i]) {
                    addToPool(w, freqScore(i, dictWords.count) - cost + contextBonus(w))
                }
            }
            if lang == "bi" {
                for (i, w) in WordLists.en.enumerated().prefix(4000)
                where !foldedEN[i].hasPrefix(fp) {
                    if let cost = editCostOne(fp, foldedEN[i]) {
                        addToPool(w, freqScore(i, WordLists.en.count) - cost + contextBonus(w))
                    }
                }
            }
        }
        // v0.21: the word -> emoji offer lives in emojiSlot(), last chip.
        let ranked = pool.values
            .sorted { $0.score != $1.score ? $0.score > $1.score : $0.seq < $1.seq }
        // v0.34i (Brian): a winner whose folded twin carries a
        // tilde in the dictionary shows BOTH surfaces — "esta" and
        // "está" — instead of the pool's folded key swallowing
        // one of them; with 8 chips there is room for the pair.
        var out: [String] = []
        for e in ranked {
            out.append(e.word)
            if let sib = accentSibling(of: e.word), !out.contains(sib) {
                out.append(sib)
            }
            // v0.36i (Brian): English contractions are the same
            // story as the tildes — the frequency lists are
            // letters-only, so "don't" can never be a pool word.
            // Its plain twin is: offer the pair (dont / don't,
            // im / I'm, cant / can't...) whenever English is on.
            if lang != "es", let twin = contractionTwin(of: e.word), !out.contains(twin) {
                out.append(twin)
            }
            if out.count >= 8 { break }
        }
        return Array(out.prefix(8))
    }

    /// v0.34i: folded form -> its dictionary surfaces, for words
    /// that live in two surfaces (esta/está, que/qué, si/sí...).
    private lazy var foldedSiblings: [String: [String]] = {
        var m: [String: [String]] = [:]
        for w in WordLists.es + WordLists.en {
            let f = fold(w)
            if m[f] == nil { m[f] = [w] }
            else if !m[f]!.contains(w) { m[f]!.append(w) }
        }
        return m
    }()
    private func accentSibling(of word: String) -> String? {
        guard let group = foldedSiblings[fold(word)], group.count > 1 else { return nil }
        return group.first { $0 != word }
    }

    /// v0.36i: letters-only form -> contraction surface. The
    /// standard English contractions; the plain form is what the
    /// dictionary holds, the apostrophe form is what he wants
    /// to be able to tap.
    private static let contractions: [String: String] = [
        "dont": "don't", "cant": "can't", "wont": "won't",
        "isnt": "isn't", "arent": "aren't", "didnt": "didn't",
        "doesnt": "doesn't", "couldnt": "couldn't",
        "wouldnt": "wouldn't", "shouldnt": "shouldn't",
        "havent": "haven't", "hasnt": "hasn't", "hadnt": "hadn't",
        "wasnt": "wasn't", "werent": "weren't", "aint": "ain't",
        "mustnt": "mustn't", "neednt": "needn't",
        "im": "I'm", "ive": "I've", "ill": "I'll", "id": "I'd",
        "youre": "you're", "youve": "you've", "youll": "you'll",
        "youd": "you'd",
        "hes": "he's", "hell": "he'll",
        "shes": "she's", "shell": "she'll",
        "its": "it's", "itll": "it'll",
        "weve": "we've", "were": "we're", "wed": "we'd",
        "theyre": "they're", "theyve": "they've",
        "theyll": "they'll", "theyd": "they'd",
        "lets": "let's", "thats": "that's", "whats": "what's",
        "wheres": "where's", "heres": "here's", "theres": "there's",
        "whos": "who's", "hows": "how's", "whens": "when's",
    ]
    private func contractionTwin(of word: String) -> String? {
        Self.contractions[fold(word)]
    }

    /// v0.37i (Brian): the word on the chip is the very word he
    /// typed, and NEITHER dictionary knows it — a name, a place,
    /// his own word (his case: "Chichibu", typed at work, tapped
    /// on its lone chip, and NOT saved). Tapping that chip saves
    /// it to My Words, the way tapping the quoted word on other
    /// keyboards adds it to the user dictionary.
    private func isSaveable(_ word: String, typed: String) -> Bool {
        let f = fold(word)
        guard f.count >= 2, f == fold(typed) else { return false }
        // v0.40i (Brian): a word already in My Words is NOT
        // saveable — the quotes mean "tap to save me", and
        // showing them for a word he already saved (his rumir,
        // saved and still quoted) makes it look unsaved.
        if personal.contains(where: { fold($0) == f }) { return false }
        return !foldedESSet.contains(f) && !foldedENSet.contains(f)
    }

    /// v0.21 (Brian): the SIXTH chip (bottom-right) belongs to
    /// emojis alone — the word->emoji match for what he is typing
    /// (two-word pair first, then the single word; the bilingual
    /// map, consulted in both languages as always), or, when
    /// nothing matches, his most-used emoji.
    private func emojiSlot() -> String {
        let prefix = localWord
        if !prefix.isEmpty {
            let fp = fold(prefix)
            if let ctx = textDocumentProxy.documentContextBeforeInput,
               ctx.count > prefix.count {
                let before = String(ctx.dropLast(prefix.count))
                if let prev = before.split(separator: " ").last,
                   let hit = EmojiData.wordEmoji[fold(String(prev)) + " " + fp] {
                    return hit
                }
            }
            if let hit = EmojiData.wordEmoji[fp] { return hit }
            // v0.34i: the official CLDR names, English + Spanish.
            if let hit = EmojiData.nameEmoji[fp] { return hit }
        }
        return topEmojis().first ?? "😀"
    }

    // MARK: - v0.35i emoji search (Brian): a 🔍 on the emoji page
    // opens a search over the official names. The letters page
    // stays up, but keys feed the query; the bar shows the query
    // on chip 1, up to 7 result emojis, and ✕. A tap on a result
    // inserts it into the document and closes the search.
    private var emojiSearchOn = false
    private var emojiQuery = ""
    private var emojiResults: [String] = []

    /// emoji -> the folded words that summon it (the name index
    /// and his curated pairs, inverted), in emoji-page order.
    private lazy var emojiWords: [(emoji: String, words: [String])] = {
        var m: [String: [String]] = [:]
        for (w, e) in EmojiData.nameEmoji { m[e, default: []].append(w) }
        for (w, e) in EmojiData.wordEmoji where !(m[e]?.contains(w) ?? false) {
            m[e, default: []].append(w)
        }
        return EmojiData.all.compactMap { e in m[e].map { (emoji: e, words: $0) } }
    }()

    private func computeEmojiResults() -> [String] {
        let qw = emojiQuery.components(separatedBy: CharacterSet.letters.inverted)
            .map { fold($0) }.filter { !$0.isEmpty }
        guard !qw.isEmpty else { return Array(topEmojis().prefix(7)) }
        var exact: [String] = []
        var prefixOnly: [String] = []
        for item in emojiWords {
            var ok = true
            var allExact = true
            for q in qw {
                if item.words.contains(q) { continue }
                if item.words.contains(where: { $0.hasPrefix(q) }) { allExact = false; continue }
                ok = false; break
            }
            if ok {
                if allExact { exact.append(item.emoji) } else { prefixOnly.append(item.emoji) }
            }
        }
        return Array((exact + prefixOnly).prefix(7))
    }

    private func renderEmojiSearch() {
        emojiResults = computeEmojiResults()
        chips[0].setTitle(emojiQuery.isEmpty ? "🔍 busca un emote…" : "🔍 " + emojiQuery, for: .normal)
        chips[0].isEnabled = true
        chips[0].alpha = 1
        for i in 1...7 {
            let chip = chips[i]
            if i - 1 < emojiResults.count {
                chip.setTitle(emojiResults[i - 1], for: .normal)
                chip.titleLabel?.font = .systemFont(ofSize: 20)
                chip.isEnabled = true
                chip.alpha = 1
            } else {
                chip.setTitle("", for: .normal)
                chip.isEnabled = false
                chip.alpha = 0.35
            }
        }
        chips[8].setTitle("✕", for: .normal)
        chips[8].isEnabled = true
        chips[8].alpha = 1
    }

    @objc private func emojiSearchTapped() {
        emojiSearchOn = true
        emojiQuery = ""
        showLetters()
        updateSuggestions()
    }

    private func exitEmojiSearch() {
        emojiSearchOn = false
        emojiQuery = ""
        for chip in chips {
            chip.titleLabel?.font = .systemFont(ofSize: chipFont, weight: .medium)
        }
        updateSuggestions()
    }

    /// v0.9 (Brian): a chip shows the word AS IT WILL BE INSERTED —
    /// capitalised at a sentence start (Shift on), plain mid-sentence.
    private func displayForm(_ w: String) -> String {
        guard shift != .off, let f = w.first else { return w }
        return f.uppercased() + w.dropFirst()
    }

    private func updateSuggestions() {
        // v0.35i: while the emoji search is open, the bar is the
        // search UI — query, results, ✕.
        if emojiSearchOn { renderEmojiSearch(); return }
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
        if let g = glideChips, glideInserted != nil {
            currentSuggestions = Array(g.prefix(8))
            editSuffix = ""
        } else {
            // v0.31i (Brian's screenshot, 2026-11-24): the mirror
            // localWord is kept by blind append/removeLast and can
            // desync from the document when he goes back into a
            // word (his chips were computed for "q" while the field
            // clearly held "porq"). From now on the DOCUMENT is the
            // truth at compute time, whatever path led here; a SUGG
            // log line marks every resync so his touch log shows
            // exactly what the keyboard saw.
            let proxyWord = currentWord()
            if proxyWord != localWord {
                if logEnabled { logEvent(k: "SUGG", m: "resync \(localWord)->\(proxyWord) suf=\(wordSuffix())", viewPoint: .zero, frame: nil) }
                localWord = proxyWord
            }
            // v0.30i (Brian): cursor INSIDE a word (he went back to
            // fix it) — judge the WHOLE word, letters after the
            // cursor included, not just the fresh prefix he is
            // retyping. And every offer wears the typed case.
            editSuffix = wordSuffix()
            let target = editSuffix.isEmpty ? localWord : localWord + editSuffix
            currentSuggestions = computeSuggestions(for: target).map { typedCaseForm($0) }
            if let u = undoOffer {
                currentSuggestions = Array(([u.original] + currentSuggestions).prefix(8))
            }
            // v0.38i (Brian): his own word ALWAYS has the first
            // seat. "rumir" got eight near-words and no quoted
            // chip to save it with, because the verbatim word
            // only reached the bar when some source happened to
            // offer it (Ogawamachi was luck). Now an unknown
            // typed word leads the bar — in quotes, via the
            // saveable rendering — and tapping it saves it.
            if target.count >= 2, !isKnownWord(target),
               !currentSuggestions.contains(where: { fold($0) == fold(target) }) {
                currentSuggestions = Array(([target] + currentSuggestions).prefix(8))
            }
        }
        // v0.37i: the saveable typed word wears quotes, like the
        // undo offer — his signal that tapping it keeps it in
        // My Words.
        let saveTarget = localWord + editSuffix
        let saveableIdx = (glideInserted == nil && undoOffer == nil && !saveTarget.isEmpty)
            ? currentSuggestions.firstIndex { isSaveable($0, typed: saveTarget) } : nil
        for (i, chip) in chips.enumerated() {
            if i < currentSuggestions.count {
                if i == 0, undoOffer != nil {
                    chip.setTitle("\"\(currentSuggestions[0])\"", for: .normal)
                } else if i == saveableIdx {
                    chip.setTitle("\"\(currentSuggestions[i])\"", for: .normal)
                } else {
                    chip.setTitle(displayForm(currentSuggestions[i]), for: .normal)
                }
                chip.isEnabled = true
                chip.alpha = 1
            } else {
                chip.setTitle("", for: .normal)
                chip.isEnabled = false
                chip.alpha = 0.35
            }
        }
        // v0.21: chip 6 (bottom-right) is the emoji slot, always live.
        let slot = chips[8]
        slot.setTitle(emojiSlot(), for: .normal)
        slot.isEnabled = true
        slot.alpha = 1
    }

    @objc private func chipTapped(_ sender: UIButton) {
        let i = sender.tag
        // v0.35i: in emoji search the chips ARE the search UI —
        // chip 1 (the query) and chip 9 (✕) close it; the middle
        // chips insert their emoji into the document.
        if emojiSearchOn {
            if i == 0 || i == 8 { exitEmojiSearch(); return }
            let idx = i - 1
            if idx < emojiResults.count {
                let e = emojiResults[idx]
                textDocumentProxy.insertText(e)
                recordEmojiUse(e)
                exitEmojiSearch()
            }
            return
        }
        // v0.21: chip 6 is the emoji slot — it inserts AT the cursor
        // without eating the word he is typing, adds no space, and
        // never learns; it only counts as emoji use.
        if i == 8 {
            let e = emojiSlot()
            textDocumentProxy.insertText(e)
            recordEmojiUse(e)
            updateSuggestions()
            return
        }
        // v0.23: a chip tap right after a glide replaces the guessed
        // word (and its trailing space) with the chosen candidate.
        if let inserted = glideInserted, let g = glideChips, i < g.count {
            for _ in 0..<(inserted.count + 1) { textDocumentProxy.deleteBackward() }
            var word = g[i]
            if shift != .off {
                word = word.prefix(1).uppercased() + word.dropFirst()
                if shift == .once { shift = .off; applyShiftVisuals() }
            }
            textDocumentProxy.insertText(word)
            learn(word)
            noteCompleted(word)
            textDocumentProxy.insertText(" ")
            lastSpaceAt = Date()   // v0.30i: same double-space courtesy as a word chip
            glideInserted = word
            autoShiftIfNeeded()
            updateSuggestions()
            return
        }
        // v0.33i: chip 1 right after a correction is the UNDO
        // offer — his original word, in quotes. One tap swaps the
        // fix back out and the corrector never touches it again.
        if i == 0, let u = undoOffer {
            pendingUndo = nil
            for _ in 0..<(u.corrected.count + 1) { textDocumentProxy.deleteBackward() }
            textDocumentProxy.insertText(u.original)
            learn(u.original)
            noteCompleted(u.original)
            noCorrect.insert(fold(u.original))
            wordStore.set(Array(noCorrect), forKey: noCorrectKey)
            UserDefaults.standard.set(Array(noCorrect), forKey: noCorrectKey)
            textDocumentProxy.insertText(" ")
            lastSpaceAt = Date()
            autoShiftIfNeeded()
            updateSuggestions()
            return
        }
        guard i < currentSuggestions.count else { return }
        // v0.37i (Brian): if the chip he taps IS the word he
        // typed (and no dictionary knows it), the tap also saves
        // it to My Words — see isSaveable.
        let saveable = isSaveable(currentSuggestions[i], typed: localWord + editSuffix)
        var savedWord: String? = nil
        var word = currentSuggestions[i]
        // v0.30i: replacing a word he went back INTO — step over the
        // letters after the cursor and eat them too, but ONLY when
        // the step really landed at the word's end (re-read to
        // check); otherwise fall back to the prefix alone.
        var deleteCount = localWord.count
        if !editSuffix.isEmpty {
            textDocumentProxy.adjustTextPosition(byCharacterOffset: editSuffix.count)
            if currentWord() == localWord + editSuffix { deleteCount += editSuffix.count }
            editSuffix = ""
        }
        for _ in 0..<deleteCount { textDocumentProxy.deleteBackward() }
        localWord = ""
        // v0.39i (Brian): the quoted word is VERBATIM — what he
        // typed is what gets inserted and saved. v0.38i turned
        // his lowercase "rumir" into "Rumir" because this shift
        // re-case ran on it (shift was pending at the tap) —
        // mid-sentence that is even grammatically wrong, his
        // words. Normal chips keep the re-case; his own word
        // never gets it.
        if !saveable, shift != .off {
            word = word.prefix(1).uppercased() + word.dropFirst()
            if shift == .once { shift = .off; applyShiftVisuals() }
        }
        textDocumentProxy.insertText(word)
        if EmojiData.wordEmojiValues.contains(word) {
            // v0.20: an emoji offer is not a word — never learn it or
            // feed it to the bigrams; count it as emoji use instead,
            // so it can climb into ⭐ Top like any tapped emoji.
            recordEmojiUse(word)
        } else {
            learn(word)
            noteCompleted(word)   // v0.6: a tapped chip also completes a word
            // v0.37i: his tap on his own unknown word saves it to
            // My Words (personal), so it is suggested from the
            // first letters next time, like Gorito or Chumaleee.
            if saveable && !personal.contains(word) {
                personal.insert(word)
                wordStore.set(Array(personal), forKey: personalKey)
                savedWord = word
                if logEnabled { logEvent(k: "CFG", m: "tap-save \(word)", viewPoint: .zero, frame: nil) }
            }
        }
        // v0.19 (Brian): the trailing space is BACK — he asked for the
        // old pattern again. The v0.7 objection (a space before the
        // punctuation typed next) is already handled: insertTextSmart
        // eats the space before . , ; : ! ? so "palabra!" stays hugged.
        textDocumentProxy.insertText(" ")
        lastSpaceAt = Date()   // v0.30i: the chip's space is space #1 for double-space -> ". "
        autoShiftIfNeeded()
        updateSuggestions()
        // v0.37i: a saved word flashes its 📌, like a pin, so he
        // SEES the tap kept it.
        if let sw = savedWord {
            chips[0].setTitle("📌 " + sw, for: .normal)
            NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                   selector: #selector(refreshBar),
                                                   object: nil)
            perform(#selector(refreshBar), with: nil, afterDelay: 1.0)
        }
    }

    // MARK: - v0.6: bigrams, personal dictionary, words manager

    /// A word was completed: count the pair (previous → this) so the
    /// bar can predict HIS next word, and remember it as the previous.
    private func noteCompleted(_ word: String) {
        if let prev = lastCompletedWord?.lowercased(), !prev.isEmpty,
           prev != word.lowercased(),
           // v0.37i (Brian): pairs are learned only when BOTH
           // words are known. An unknown word is never remembered
           // on its own — it enters through his tap, or not at all.
           isKnownWord(prev), isKnownWord(word) {
            var followers = bigrams[prev] ?? [:]
            followers[word, default: 0] += 1
            bigrams[prev] = followers
            if bigrams.count > 900 {   // prune one-hit wonders
                bigrams = bigrams.filter { $0.value.values.reduce(0, +) > 1 }
            }
            markStoreDirty()
        }
        lastCompletedWord = word
    }

    /// Long-press on a suggestion chip: pin the word as personal.
    @objc private func chipLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard !emojiSearchOn, gesture.state == .began,
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
        // v0.34i (Brian): My Words lists ONLY the words he saves
        // himself — pinned or added by hand (Gorito, Chumaleee,
        // Muse...). The invisible learning no longer floods it:
        // this page went from 42 pages of "le, it, and, my" back
        // to one short list that is actually his.
        return personal.sorted { $0.lowercased() < $1.lowercased() }
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
        // v0.19: this counted only PINNED words (personal) while the
        // editor lists pinned + learned — with 5 pinned it capped the
        // pager at 1 page and the arrow looked dead on a 25-page list.
        let pages = max(1, (allPersonalWords().count + 17) / 18)
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
            lang == "en" ? "🌐 EN" : lang == "bi" ? "🌐 ES+EN" : "🌐 ES", #selector(langToggleTapped)))
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
        flashBar("MyKeys v0.40i Guardada", "")
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
        // v0.21 (Brian): THREE modes — ES, EN, and ES+EN bilingual,
        // because he mixes both constantly in the same messages.
        lang = lang == "es" ? "en" : lang == "en" ? "bi" : "es"
        wordStore.set(lang, forKey: langKey)
        UserDefaults.standard.set(lang, forKey: langKey)
        if logEnabled { logEvent(k: "CFG", m: "lang-" + lang, viewPoint: .zero, frame: nil) }
        updateSuggestions()
        showLogPanel()   // rebuild so the label shows the new language
    }


    // MARK: - v0.11 Visual editor (Brian)

    @objc private func editorTapped() {
        edPrudent = prudentEnabled; edPopup = popupEnabled
        edSugg = suggEnabled; edSlideMode = slideMode
        edH = keyRowH; edGap = keyGap; edBorders = bordersOn
        edEnter = enterKeyOn
        edDismiss = dismissMode
        edFont = keyFont; edTheme = themeName; edHaptic = spaceHaptic
        edChipFont = chipFont
        edLang = lang
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
        sw2.addArrangedSubview(editorCyclePill("Slide: \(slideModeLabel(edSlideMode))", action: #selector(edCycleSlide)))

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

        // v0.18 (Brian's picks): letter size, theme, space haptic.
        let sF = editorRow(44)
        let lF = editorLabel("Letter size")
        lF.widthAnchor.constraint(equalToConstant: 86).isActive = true
        sF.addArrangedSubview(lF)
        let sliderF = UISlider()
        sliderF.minimumValue = 18; sliderF.maximumValue = 30
        sliderF.value = Float(edFont)
        sliderF.addTarget(self, action: #selector(edFontChanged(_:)), for: .valueChanged)
        sF.addArrangedSubview(sliderF)
        editorFontLabel = editorLabel("\(Int(edFont))")
        editorFontLabel!.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sF.addArrangedSubview(editorFontLabel!)

        let sw4 = editorRow(40)
        sw4.distribution = .fillEqually
        sw4.addArrangedSubview(editorCyclePill("Theme: \(themeLabel(edTheme))", action: #selector(edCycleTheme)))
        sw4.addArrangedSubview(editorCyclePill("Haptic: \(hapticLabel(edHaptic))", action: #selector(edCycleHaptic)))

        // v0.21 (Brian): language mode — ES, EN, or bilingual.
        let swLang = editorRow(40)
        swLang.distribution = .fillEqually
        swLang.addArrangedSubview(editorCyclePill("Language: \(langLabel(edLang))", action: #selector(edCycleLang)))

        // v0.19 (Brian): the suggestion chips get their OWN size setting.
        let sC = editorRow(44)
        let lC = editorLabel("Chip size")
        lC.widthAnchor.constraint(equalToConstant: 86).isActive = true
        sC.addArrangedSubview(lC)
        let sliderC = UISlider()
        sliderC.minimumValue = 13; sliderC.maximumValue = 24
        sliderC.value = Float(edChipFont)
        sliderC.addTarget(self, action: #selector(edChipFontChanged(_:)), for: .valueChanged)
        sC.addArrangedSubview(sliderC)
        editorChipFontLabel = editorLabel("\(Int(edChipFont))")
        editorChipFontLabel!.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sC.addArrangedSubview(editorChipFontLabel!)

        let sw3 = editorRow(40)
        sw3.distribution = .fillEqually
        sw3.addArrangedSubview(editorPill("Enter", on: edEnter, action: #selector(edToggleEnter)))
        sw3.addArrangedSubview(editorPill("Borders", on: edBorders, action: #selector(edToggleBorders)))
        sw3.addArrangedSubview(editorPill("Hide: \(dismissLabel(edDismiss))", on: edDismiss != 3, action: #selector(edCycleDismiss)))

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

        heightConstraint.constant = kbBaseHeight + 314
    }

    private func themeLabel(_ t: String) -> String {
        switch t {
        case "light": return "Light"
        case "dark": return "Dark"
        case "contrast": return "Contrast"
        default: return "Auto"
        }
    }

    private func hapticLabel(_ h: Int) -> String {
        h == 0 ? "Soft" : (h == 1 ? "Medium" : "Strong")
    }

    private func editorCyclePill(_ title: String, action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .tertiarySystemBackground
        b.layer.cornerRadius = 8
        b.addTarget(self, action: action, for: .touchUpInside)
        return b
    }

    @objc private func edCycleTheme() {
        edTheme = edTheme == "auto" ? "light"
            : edTheme == "light" ? "dark"
            : edTheme == "dark" ? "contrast" : "auto"
        buildKeyboard()
    }

    private func langLabel(_ l: String) -> String {
        l == "en" ? "EN" : l == "bi" ? "ES+EN" : "ES"
    }

    @objc private func edCycleLang() {
        edLang = edLang == "es" ? "en" : edLang == "en" ? "bi" : "es"
        buildKeyboard()
    }

    @objc private func edCycleHaptic() {
        edHaptic = (edHaptic + 1) % 3
        buildKeyboard()
    }

    @objc private func edFontChanged(_ sender: UISlider) {
        edFont = CGFloat(Int(sender.value.rounded()))
        editorFontLabel?.text = "\(Int(edFont))"
        refillEditorPreview()
    }

    @objc private func edChipFontChanged(_ sender: UISlider) {
        edChipFont = CGFloat(Int(sender.value.rounded()))
        editorChipFontLabel?.text = "\(Int(edChipFont))"
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
            b.titleLabel?.font = .systemFont(ofSize: edFont, weight: .medium)
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
    @objc private func edCycleSlide() { edSlideMode = (edSlideMode + 1) % 3; buildKeyboard() }

    private func slideModeLabel(_ m: Int) -> String {
        m == 2 ? "Words" : m == 1 ? "Letters" : "Off"
    }
    @objc private func edToggleBorders() { edBorders.toggle(); buildKeyboard() }
    @objc private func edToggleEnter() { edEnter.toggle(); buildKeyboard() }
    private func dismissLabel(_ m: Int) -> String {
        m == 1 ? "Button" : m == 2 ? "Both" : m == 3 ? "Off" : "Flick"
    }
    @objc private func edCycleDismiss() { edDismiss = (edDismiss + 1) % 4; buildKeyboard() }

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
        suggEnabled = edSugg; slideMode = edSlideMode; slideOn = edSlideMode != 0
        keyRowH = edH; keyGap = edGap; bordersOn = edBorders
        keyFont = edFont; themeName = edTheme; spaceHaptic = edHaptic
        chipFont = edChipFont
        enterKeyOn = edEnter
        dismissMode = edDismiss
        lang = edLang
        wordStore.set(edLang, forKey: langKey)
        UserDefaults.standard.set(edLang, forKey: langKey)
        for c in chips { c.titleLabel?.font = .systemFont(ofSize: chipFont, weight: .medium) }
        wordStore.set(edSlideMode, forKey: slideModeKey)
        UserDefaults.standard.set(edSlideMode, forKey: slideModeKey)
        wordStore.set(edDismiss, forKey: dismissKey)
        UserDefaults.standard.set(edDismiss, forKey: dismissKey)
        wordStore.set(edSlideMode != 0, forKey: slidePrefKey)
        UserDefaults.standard.set(edSlideMode != 0, forKey: slidePrefKey)
        // Saved in BOTH of the keyboard's own stores, like the language
        // flip: the keyboard always reads its own last word (v0.11).
        for (key, val) in [(prudentKey, edPrudent), (popupKey, edPopup),
                           (suggKey, edSugg),
                           (bordersKey, edBorders),
                           (enterKeyKey, edEnter)] {
            wordStore.set(val, forKey: key)
            UserDefaults.standard.set(val, forKey: key)
        }
        wordStore.set(Int(edH), forKey: keyHKey)
        UserDefaults.standard.set(Int(edH), forKey: keyHKey)
        wordStore.set(Int(edGap), forKey: keyGapKey)
        UserDefaults.standard.set(Int(edGap), forKey: keyGapKey)
        wordStore.set(Int(edFont), forKey: fontKey)
        UserDefaults.standard.set(Int(edFont), forKey: fontKey)
        wordStore.set(edTheme, forKey: themeKey)
        UserDefaults.standard.set(edTheme, forKey: themeKey)
        wordStore.set(edHaptic, forKey: hapticKey)
        UserDefaults.standard.set(edHaptic, forKey: hapticKey)
        wordStore.set(Int(edChipFont), forKey: chipFontKey)
        UserDefaults.standard.set(Int(edChipFont), forKey: chipFontKey)
        applyAppAppearance()   // v0.18: a new theme takes effect at once
        applyTrayColor()
        if !popupEnabled { hidePopup() }
        if logEnabled { logEvent(k: "CFG", m: "editor-done", viewPoint: .zero, frame: nil) }
        editorOpen = false
        pageCache.removeAll()   // v0.15: geometry/settings changed
        suppressNextCacheSave = true   // v0.22: don't re-save the stale page
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
        // v0.16 (Brian): ALL his words — pinned first, then everything
        // the keyboard has learned, by frequency — so he can SEE the
        // learning (v0.12 showed only the pinned ones and he rightly
        // concluded nothing was being learned).
        let words = allPersonalWords()
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
                    b.setTitleColor(keyTitleColor, for: .normal)
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
        // v0.16: the editor now lists learned words too — deleting one
        // must kill it in BOTH drawers or it would rise from the dead.
        learned[w] = nil
        learnedFolded[w] = nil
        wordStore.set(learned, forKey: learnedKey)
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
        // v0.35i: while the emoji search is open, keys feed the
        // search box, not the document.
        if emojiSearchOn {
            emojiQuery += text
            updateSuggestions()
            return
        }
        if text.count == 1, let c = text.first, !c.isLetter, c != " " {
            completeWord()   // a punctuation mark completes a word
            localWord = ""
            // v0.16 (Brian): punctuation hugs the word. "palabra" + space
            // + "!" used to stay "palabra !" — eat the space so it lands
            // as "palabra!". Only after a letter, so "3 ," and emoji are
            // untouched.
            if ".,;:!?".contains(c) {
                let before = textDocumentProxy.documentContextBeforeInput ?? ""
                if before.hasSuffix(" "),
                   let prev = before.dropLast().last, prev.isLetter {
                    textDocumentProxy.deleteBackward()
                }
            }
        }
        lastSpaceAt = nil   // any real character breaks a double-space chain
        var out = text
        if text.count == 1, text.first!.isLetter {
            out = (shift == .off) ? text.lowercased() : text.uppercased()
        }
        textDocumentProxy.insertText(out)
        if out.count == 1, let oc = out.first, oc.isLetter { localWord.append(oc); pendingUndo = nil }
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
        // v0.29i flash hypothesis (Brian reopened it 2026-11-23):
        // the keys are .system UIButtons, and a system button
        // ANIMATES every title change (fade out / fade in). 26
        // letters crossfading at once reads as a white flash.
        // Page swaps never flashed because buildKeyboard() runs
        // inside performWithoutAnimation — the shift retitle path
        // never got that treatment. Standard documented cure:
        // retitle inside performWithoutAnimation + layoutIfNeeded.
        UIView.performWithoutAnimation {
            for b in letterButtons {
                guard let base = b.accessibilityLabel else { continue }
                b.setTitle(shift == .off ? base : base.uppercased(), for: .normal)
                b.layoutIfNeeded()
            }
            shiftButton?.setTitle(shift == .off ? "⇧" : "⇪", for: .normal)
            if let sb = shiftButton {
                if shift == .off { paint(sb, normal: functionKeyColor, pressed: functionPressedColor) }
                else { paint(sb, normal: .systemOrange, pressed: .systemOrange) }
                sb.layoutIfNeeded()
            }
        }
    }

    @objc private func letterTouchedDown(_ sender: KeyButton) {
        glideChips = nil; glideInserted = nil
        guard let label = sender.accessibilityLabel ?? sender.title(for: .normal) else { return }
        if emojiSearchOn {
            emojiQuery += label
            updateSuggestions()
            return
        }
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
        // v0.23 glide typing: in Words mode a drag does NOT type — it
        // traces the word's path; the guess lands when the finger lifts.
        if slideMode == 2, via == "slide", !target.isSpaceKey,
           let raw = target.accessibilityLabel ?? target.title(for: .normal),
           let ch = fold(raw).first, ch.isLetter {
            if glidePath.isEmpty {
                glidePath = Array(fold(localWord))
                glideBaseCount = localWord.count
                glideCrossings = 0
            }
            if glidePath.last != ch { glidePath.append(ch) }
            glideCrossings += 1
            keyTouchedDown(target)
            return
        }
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

    /// v0.25: collect the trace's raw points while gliding (thinned
    /// to ~6pt spacing so the scorer stays fast).
    private func recordGlidePoint(_ pt: CGPoint) {
        guard slideMode == 2 else { return }
        if let last = glidePoints.last, hypot(pt.x - last.x, pt.y - last.y) < 6 { return }
        if glidePoints.count < 400 { glidePoints.append(pt) }
    }

    /// v0.23: the finger lifted. In Words mode, if the drag really
    /// crossed keys, turn the traced path into a word.
    private func slideEnded() {
        let path = glidePath
        let crossings = glideCrossings
        let base = glideBaseCount
        let pts = glidePoints
        glidePath = []; glideCrossings = 0; glideBaseCount = 0; glidePoints = []
        if emojiSearchOn { return }   // v0.35i: no gliding into a search
        guard slideMode == 2 else { return }
        guard variantStrip == nil || variantStrip.isHidden else { return }
        guard crossings >= 1, path.count >= 2 else { return }
        let cands = glideCandidates(path: path, points: pts)
        // v0.24: every real trace goes to the touch log with its
        // outcome, so a bad glide is data, not a mystery.
        if logEnabled {
            logEvent(k: "GLIDE", m: "\(String(path))>\(cands.first ?? "∅")",
                     viewPoint: .zero, frame: nil)
        }
        guard let best = cands.first else {
            // v0.24 fallback: no guess — type the letters he traced
            // (what Letters mode would have written) instead of
            // leaving him with the single touch-down letter.
            if path.count > base {
                for ch in path[base...] { insertTextSmart(String(ch)) }
                updateSuggestions()
            }
            return
        }
        for _ in 0..<base { textDocumentProxy.deleteBackward() }
        localWord = ""
        var word = best
        if shift != .off {
            word = word.prefix(1).uppercased() + word.dropFirst()
            if shift == .once { shift = .off; applyShiftVisuals() }
        }
        textDocumentProxy.insertText(word)
        learn(word)
        noteCompleted(word)
        textDocumentProxy.insertText(" ")
        glideInserted = word
        glideChips = cands
        autoShiftIfNeeded()
        updateSuggestions()
    }

    /// v0.28i glide — the OTHER PLAN (Brian's call, 2026-11-19,
    /// after the geometric scorer also failed his traces):
    /// FlorisBoard's StatisticalGlideTypingClassifier, ported
    /// faithfully from their Apache-2.0 Kotlin (itself from
    /// AnySoftKeyboard). The user trace and each candidate word's
    /// IDEAL gesture (a polyline through the word's key centres)
    /// are both resampled to 200 points; two Gaussians score the
    /// match — SHAPE (bounding-box-normalized, std 22.08) and
    /// LOCATION (raw Manhattan, std 0.5109 x key radius) — and
    /// word frequency multiplies in. Candidates are pruned by
    /// (first, last) key buckets (2 closest keys at each end) and
    /// by ideal-gesture length (8.42 x radius). Double letters get
    /// a second ideal gesture with a little LOOP around the key,
    /// so "pool" and "poll" can be told apart. Scores are computed
    /// in log space (same ranking, no underflow). His bigram
    /// context stays on top as a small bonus.
    private func glideCandidates(path: [Character], points: [CGPoint]) -> [String] {
        guard points.count >= 2 else { return [] }
        // Key centres + size, in window coordinates (same as points).
        var centres: [Character: CGPoint] = [:]
        var keyW = 0.0, keyH = 0.0
        for b in KeyButton.slideTargets {
            guard let raw = b.accessibilityLabel ?? b.title(for: .normal),
                  let ch = fold(raw).first else { continue }
            let f = KeyButton.frameCache[ObjectIdentifier(b)] ?? b.convert(b.bounds, to: nil)
            centres[ch] = CGPoint(x: f.midX, y: f.midY)
            if keyW == 0 { keyW = Double(f.width); keyH = Double(f.height) }
        }
        guard centres.count >= 20, keyW > 0 else { return [] }
        let radius = min(keyW, keyH)
        // FlorisBoard thins gesture points: a new point must be at
        // least keyWidth/4 away from the last kept one.
        let thinSq = (keyW / 4) * (keyW / 4)
        var trace: [CGPoint] = []
        for pt in points {
            if let last = trace.last {
                let dx = Double(pt.x - last.x), dy = Double(pt.y - last.y)
                if dx * dx + dy * dy <= thinSq { continue }
            }
            trace.append(pt)
        }
        guard trace.count >= 2 else { return [] }
        let userResampled = glideResample(trace, 200)
        let userNorm = glideNormalize(userResampled)
        let userLength = glideLength(trace)
        // Prune by extremities: the 2 closest keys to each end.
        func closest2(_ pt: CGPoint) -> [Character] {
            centres.sorted { a, b in
                hypot(pt.x - a.value.x, pt.y - a.value.y)
                    < hypot(pt.x - b.value.x, pt.y - b.value.y)
            }.prefix(2).map { $0.key }
        }
        let startKeys = closest2(trace.first!)
        let endKeys = closest2(trace.last!)
        let prevFollowers: [String: Int]? = lastCompletedWord.flatMap { bigrams[$0.lowercased()] }
        var best: [String: (word: String, score: Double)] = [:]
        func consider(_ surface: String, foldedForm: String, freqProb: Double) {
            guard foldedForm.count >= 2 else { return }
            // Ideal gestures: plain + loop variant for double letters.
            var plain: [CGPoint] = []
            var loops: [CGPoint] = []
            var hasLoops = false
            var prev: Character? = nil
            for ch in foldedForm {
                guard let c = centres[ch] else { continue }
                plain.append(c)
                if prev == ch {
                    hasLoops = true
                    let dx = CGFloat(keyW / 4), dy = CGFloat(keyH / 4)
                    loops.append(CGPoint(x: c.x + dx, y: c.y + dy))
                    loops.append(CGPoint(x: c.x + dx, y: c.y - dy))
                    loops.append(CGPoint(x: c.x - dx, y: c.y - dy))
                    loops.append(CGPoint(x: c.x - dx, y: c.y + dy))
                } else {
                    loops.append(c)
                }
                prev = ch
            }
            guard plain.count >= 2 else { return }
            // Length pruning (FlorisBoard: 8.42 x radius).
            if abs(userLength - glideLength(plain)) >= 8.42 * radius { return }
            var score = -Double.greatestFiniteMagnitude
            let variants = hasLoops ? [plain, loops] : [plain]
            for v in variants {
                let rs = glideResample(v, 200)
                let shape = glideShapeDistance(glideNormalize(rs), userNorm)
                let loc = glideLocationDistance(rs, userResampled)
                let s = glideLogGauss(shape, 22.08)
                    + glideLogGauss(loc, 0.5109 * radius)
                    + log(max(freqProb, 0.0005))
                if s > score { score = s }
            }
            if let fol = prevFollowers,
               let c = fol[surface] ?? fol[surface.lowercased()] {
                score += min(1.5, Double(c) * 0.3)
            }
            if score > (best[foldedForm]?.score ?? -Double.greatestFiniteMagnitude) {
                best[foldedForm] = (surface, score)
            }
        }
        // Candidate pool from the (first, last) buckets.
        let listSpecs: [([String], [String], String)] = lang == "en"
            ? [(WordLists.en, foldedEN, "en")]
            : lang == "bi" ? [(WordLists.es, foldedES, "es"), (WordLists.en, foldedEN, "en")]
            : [(WordLists.es, foldedES, "es")]
        for (words, folded, code) in listSpecs {
            let pairs = glidePairs(for: code, folded: folded)
            var idxs = Set<Int>()
            for s in startKeys { for e in endKeys {
                if let b = pairs["\(s)\(e)"] { idxs.formUnion(b) }
            } }
            let total = Double(words.count)
            for i in idxs {
                consider(words[i], foldedForm: folded[i],
                         freqProb: (total - Double(i)) / total)
            }
        }
        for w in personal { consider(w, foldedForm: fold(w), freqProb: 0.999) }
        for (w, _) in learned { consider(w, foldedForm: fold(w), freqProb: 0.99) }
        return best.values.sorted { $0.score > $1.score }.prefix(8).map { $0.word }
    }

    /// v0.28i: per-language (first, last) folded-letter buckets —
    /// the FlorisBoard pruner's word tree. Built once, lazily.
    private var pairCacheES: [String: [Int]]? = nil
    private var pairCacheEN: [String: [Int]]? = nil
    private func glidePairs(for code: String, folded: [String]) -> [String: [Int]] {
        if code == "en", let p = pairCacheEN { return p }
        if code == "es", let p = pairCacheES { return p }
        var pairs: [String: [Int]] = [:]
        for (i, w) in folded.enumerated() {
            guard let f = w.first, let l = w.last else { continue }
            pairs["\(f)\(l)", default: []].append(i)
        }
        if code == "en" { pairCacheEN = pairs } else { pairCacheES = pairs }
        return pairs
    }

    /// Resample a polyline to exactly n points, evenly by arc length.
    private func glideResample(_ pts: [CGPoint], _ n: Int) -> [CGPoint] {
        guard pts.count >= 2 else { return pts }
        let total = glideLength(pts)
        guard total > 0 else { return Array(repeating: pts[0], count: n) }
        let step = total / Double(n - 1)
        var out: [CGPoint] = [pts[0]]
        var prev = pts[0]
        var acc = 0.0
        var i = 1
        while i < pts.count && out.count < n {
            let cur = pts[i]
            let d = Double(hypot(cur.x - prev.x, cur.y - prev.y))
            if acc + d >= step, d > 0 {
                let t = CGFloat((step - acc) / d)
                let np = CGPoint(x: prev.x + t * (cur.x - prev.x),
                                 y: prev.y + t * (cur.y - prev.y))
                out.append(np)
                prev = np
                acc = 0
            } else {
                acc += d
                prev = cur
                i += 1
            }
        }
        while out.count < n { out.append(pts.last!) }
        return out
    }

    private func glideLength(_ pts: [CGPoint]) -> Double {
        var L = 0.0
        if pts.count < 2 { return 0 }
        for i in 1..<pts.count {
            L += Double(hypot(pts[i].x - pts[i - 1].x, pts[i].y - pts[i - 1].y))
        }
        return L
    }

    /// FlorisBoard normalizeByBoxSide: divide by the longest
    /// bounding-box side and centre on the box centroid.
    private func glideNormalize(_ pts: [CGPoint]) -> [CGPoint] {
        var minX = Double.greatestFiniteMagnitude, maxX = -Double.greatestFiniteMagnitude
        var minY = Double.greatestFiniteMagnitude, maxY = -Double.greatestFiniteMagnitude
        for p in pts {
            minX = min(minX, Double(p.x)); maxX = max(maxX, Double(p.x))
            minY = min(minY, Double(p.y)); maxY = max(maxY, Double(p.y))
        }
        let side = max(max(maxX - minX, maxY - minY), 0.00001)
        let cx = ((maxX - minX) / 2 + minX) / side
        let cy = ((maxY - minY) / 2 + minY) / side
        return pts.map { CGPoint(x: Double($0.x) / side - cx,
                                 y: Double($0.y) / side - cy) }
    }

    /// SUM of Euclidean distances over the resampled points
    /// (FlorisBoard does not average the shape distance).
    private func glideShapeDistance(_ a: [CGPoint], _ b: [CGPoint]) -> Double {
        var t = 0.0
        for i in 0..<min(a.count, b.count) {
            t += Double(hypot(a[i].x - b[i].x, a[i].y - b[i].y))
        }
        return t
    }

    /// Mean Manhattan distance / 2 (FlorisBoard's location distance).
    private func glideLocationDistance(_ a: [CGPoint], _ b: [CGPoint]) -> Double {
        let n = min(a.count, b.count)
        guard n > 0 else { return 0 }
        var t = 0.0
        for i in 0..<n { t += Double(abs(a[i].x - b[i].x) + abs(a[i].y - b[i].y)) }
        return t / Double(n) / 2
    }

    private func glideLogGauss(_ v: Double, _ std: Double) -> Double {
        -log(std * sqrt(2 * Double.pi)) - 0.5 * (v / std) * (v / std)
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
        if emojiSearchOn {
            emojiQuery += " "
            updateSuggestions()
            return
        }
        glideChips = nil; glideInserted = nil   // v0.23: a fresh space ends the glide offer
        pendingVariantKey = nil; pendingBaseChar = nil   // v0.4: word boundary
        completeWord()   // the word before this space is complete
        localWord = ""
        let now = Date()
        let before = textDocumentProxy.documentContextBeforeInput ?? ""
        // Double space → ". " (Brian, V1.6): two quick spaces after a word
        // become period + space, and auto-shift capitalises the next word.
        // (The learn call above is a no-op in this branch: the context
        // ends with the first space, so there is no current word.)
        if let last = lastSpaceAt, now.timeIntervalSince(last) < 0.4 {
            // v0.30i (Brian): count ALL trailing spaces — after a
            // chip tap there can be two (the chip's + his), and the
            // old check only looked past ONE space, so the period
            // never came. Eat them all, then ". ".
            let trailing = before.reversed().prefix(while: { $0 == " " }).count
            if trailing > 0, let prev = before.dropLast(trailing).last,
               prev.isLetter || prev.isNumber {
                for _ in 0..<trailing { textDocumentProxy.deleteBackward() }
                textDocumentProxy.insertText(". ")
                lastSpaceAt = nil
                autoShiftIfNeeded()
                updateSuggestions()
                return
            }
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

    /// v0.30i: the swipe-down handler (wired in viewDidLoad). Fires
    /// once per gesture: a long, mostly-vertical downward drag that
    /// started above the bottom row hides the keyboard.
    private var dismissStartY: CGFloat = 0
    /// v0.32i: the little hide button at the space bar's right
    /// (Editor -> Hide: Button or Both).
    @objc private func dismissButtonTapped() { dismissKeyboard() }

    @objc private func dismissPanMoved(_ g: UIPanGestureRecognizer) {
        if g.state == .began { dismissStartY = g.location(in: view).y }
        guard g.state == .changed, dismissMode == 0 || dismissMode == 2 else { return }
        let t = g.translation(in: view)
        let startedAboveBottomRow = dismissStartY < view.bounds.height - keyRowH - 8
        if startedAboveBottomRow && t.y > 80 && t.y > 2.2 * abs(t.x) {
            g.isEnabled = false
            g.isEnabled = true   // stop this gesture firing twice
            dismissKeyboard()   // UIInputViewController's own API — the extension-safe way
        }
    }

    @objc private func returnTapped() {
        if emojiSearchOn { exitEmojiSearch(); return }   // v0.35i
        glideChips = nil; glideInserted = nil   // v0.23
        pendingVariantKey = nil; pendingBaseChar = nil   // v0.4
        completeWord()
        localWord = ""
        lastCompletedWord = nil   // v0.6: a new line starts a new phrase
        textDocumentProxy.insertText("\n")
        // v0.19 (Brian): a new paragraph starts capitalised — set the
        // shift HERE instead of trusting textDidChange to do it later.
        if mode == .letters, shift == .off {
            shift = .once
            applyShiftVisuals()
        }
        updateSuggestions()
    }

    @objc private func deleteTapped() {
        if emojiSearchOn {
            if !emojiQuery.isEmpty { emojiQuery.removeLast() }
            updateSuggestions()
            return
        }
        pendingUndo = nil   // v0.33i
        glideChips = nil; glideInserted = nil   // v0.23
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
