import SwiftUI

// Describe prompts (v0.25i): Brian describes each prompt in his
// own words with MyKeys — no copying, so his head is on the
// keyboard, not on a text. v0.28i (Brian, 2026-11-19): ten prompts
// were too many — only FOUR now: two in Spanish, two in English.
private let prompts: [String] = [
    "Describe a Pelusa: cómo se ve, qué hace todo el día y cuáles son sus mañas.",
    "Describe Ogawamachi: sus calles, el río, las montañas y la gente.",
    "Describe this scene in your own words: a penguin with a backpack arrives at a small train station in Japan.",
    "Describe your car, El Chato: the color, the inside, and where you like to drive it."
]

// v0.8 (Brian): the app and the keyboard share ONE drawer (App Groups)
// for his personal dictionary. Same group ID and same key as the
// keyboard's wordStore. If SideStore does not let the drawer be
// shared, this page simply will not reach the keyboard — the test is:
// add a word here, then see if the keyboard suggests it.
private let appGroupID = "group.com.brianklauer.briankeys"
private let personalKey = "bk_personal_v1"
// v0.9 (Brian): the keyboard's switches live HERE now, not in the
// keyboard's panel. Same keys the keyboard reads (shared-first).
private let prudentKey = "bk_prudent_v1"
private let popupKey = "bk_popup_v1"
private let suggKey = "bk_sugg_v1"
private let slideKey = "bk_slide_on_v1"

struct OptionsView: View {
    @State private var corrector = false
    @State private var popup = true
    @State private var sugerencias = true
    @State private var slide = true

    private var store: UserDefaults? { UserDefaults(suiteName: appGroupID) }

    private func load() {
        guard let store else { return }
        corrector = store.object(forKey: prudentKey) as? Bool ?? false
        popup = store.object(forKey: popupKey) as? Bool ?? true
        sugerencias = store.object(forKey: suggKey) as? Bool ?? true
        slide = store.object(forKey: slideKey) as? Bool ?? true
    }

    private func save() {
        store?.set(corrector, forKey: prudentKey)
        store?.set(popup, forKey: popupKey)
        store?.set(sugerencias, forKey: suggKey)
        store?.set(slide, forKey: slideKey)
    }

    var body: some View {
        Form {
            Section {
                Toggle("Prudent correction", isOn: $corrector)
                Toggle("Key popup when tapping", isOn: $popup)
                Toggle("Suggestions", isOn: $sugerencias)
                Toggle("Slide: drag to type", isOn: $slide)
            } footer: {
                Text("These settings travel to the keyboard through the same shared drawer as the dictionary. If a setting does not show up on the keyboard, the drawer was not shared: tell Muse.")
            }
        }
        .navigationTitle("⚙️ Options")
        .onAppear { load() }
        .onChange(of: corrector) { _, _ in save() }
        .onChange(of: popup) { _, _ in save() }
        .onChange(of: sugerencias) { _, _ in save() }
        .onChange(of: slide) { _, _ in save() }
    }
}

struct DictionaryView: View {
    @State private var words: [String] = []
    @State private var newWord: String = ""
    @State private var drawerMissing = false

    private var store: UserDefaults? { UserDefaults(suiteName: appGroupID) }

    private func load() {
        guard let store else { drawerMissing = true; return }
        words = (store.stringArray(forKey: personalKey) ?? []).sorted()
    }

    private func save() {
        store?.set(words, forKey: personalKey)
    }

    private func add() {
        let w = newWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !w.isEmpty, !words.contains(w) else { newWord = ""; return }
        words.append(w)
        words.sort()
        save()
        newWord = ""
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("Palabra nueva…", text: $newWord)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .onSubmit { add() }
                Button("Add") { add() }
                    .buttonStyle(.borderedProminent)
                    .disabled(newWord.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)

            if drawerMissing {
                Text("The shared drawer could not be opened on this install. Tell Muse.")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }

            if words.isEmpty {
                Text("You have no words yet. Add your first one above, or pin one from the keyboard with a long-press on a suggestion (📌).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                List {
                    ForEach(words, id: \.self) { w in
                        Text(w)
                    }
                    .onDelete { idx in
                        words.remove(atOffsets: idx)
                        save()
                    }
                }
                .listStyle(.plain)
            }

            Text("Swipe a word left to delete it. Drawer test: add a word here and check whether the keyboard suggests it.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding(.top)
        .navigationTitle("📖 My dictionary")
        .onAppear { load() }
    }
}

struct ContentView: View {
    @State private var attempts: [String] = Array(repeating: "", count: prompts.count)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("MyKeys")
                            .font(.title2)
                            .bold()
                        // v0.4 (Brian): the version sits right of the title so
                        // he can confirm at a glance what is installed.
                        Text("v0.40i")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text("Enable it in Settings → General → Keyboard → Keyboards → MyKeys, and do not forget “Allow Full Access” (the haptics need it).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // v0.8 (Brian): his personal dictionary lives here in
                    // the app — add and delete words without opening the
                    // keyboard panel.
                    NavigationLink {
                        DictionaryView()
                    } label: {
                        HStack {
                            Text("📖 My personal dictionary")
                                .font(.headline)
                            Spacer()
                            Text("›")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    // v0.9 (Brian): the keyboard's switches moved here.
                    NavigationLink {
                        OptionsView()
                    } label: {
                        HStack {
                            Text("⚙️ Keyboard options")
                                .font(.headline)
                            Spacer()
                            Text("›")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    // v0.34i (Brian): the emoji names page — how every
                    // emote is called, in Spanish and English.
                    NavigationLink {
                        EmojiNamesView()
                    } label: {
                        HStack {
                            Text("🔤 Emoji names")
                                .font(.headline)
                            Spacer()
                            Text("›")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    Divider()

                    Text("Describe prompts")
                        .font(.title3)
                        .bold()

                    Text("Describe each prompt in your own words, right here with MyKeys. Think about the idea, not about copying: concentrate on the keyboard. Do NOT fix the typos: the typos are the data. At the end, tap “Copy ALL” and paste it all into the chat in one go.")
                        .font(.body)

                    HStack {
                        Button("📋 Copy ALL") {
                            var parts = ["MyKeys — resultados de la suite"]
                            for i in prompts.indices where !attempts[i].isEmpty {
                                parts.append("\(i + 1). Prompt: \(prompts[i])\n   Escrito: \(attempts[i])")
                            }
                            UIPasteboard.general.string = parts.joined(separator: "\n")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(attempts.allSatisfy { $0.isEmpty })

                        Button("Clear all") {
                            attempts = Array(repeating: "", count: prompts.count)
                        }
                        .buttonStyle(.bordered)
                        .disabled(attempts.allSatisfy { $0.isEmpty })
                    }

                    ForEach(prompts.indices, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(i + 1). \(prompts[i])")
                                .font(.headline)

                            TextField("Your attempt…", text: $attempts[i], axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(2...5)
                                // The test must measure BrianKeys alone, so the
                                // field itself neither corrects nor capitalises.
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)

                            HStack {
                                Button("Copy attempt 📋") {
                                    UIPasteboard.general.string = attempts[i]
                                }
                                .buttonStyle(.bordered)
                                .disabled(attempts[i].isEmpty)

                                Button("Clear") {
                                    attempts[i] = ""
                                }
                                .buttonStyle(.bordered)
                                .disabled(attempts[i].isEmpty)
                            }
                        }
                        .padding(.vertical, 4)

                        Divider()
                    }

                    Spacer(minLength: 0)
                }
                .padding()
            }
        }
    }
}
