import SwiftUI

// The fixed test suite. Same texts every build so versions compare honestly.
// Written in Brian's real style: closing ? and ! only, never opening ¿ ¡
// (the keyboard still offers ¿ ¡ on long-press, for completeness).
private let testTexts: [String] = [
    "Hola, amigos. Estamos probando el teclado nuevo.",
    "Ven conmigo, no me canso nunca, ven ven ven",
    "Cómo estás, niño? Qué alegría más grande!!!",
    "The quick brown fox jumps over the lazy dog",
    "Leo sale a las 3:30 y vuelve el 15 de mayo",
    "chumaleeee, wokiii, tamos contat? cheverazo!!!",
    "PRUEBA CIEGA: el texto 1 otra vez, sin mirar el teclado, ojos solo en el texto."
]

// v0.8 (Brian): the app and the keyboard share ONE drawer (App Groups)
// for his personal dictionary. Same group ID and same key as the
// keyboard's wordStore. If SideStore does not let the drawer be
// shared, this page simply will not reach the keyboard — the test is:
// add a word here, then see if the keyboard suggests it.
private let appGroupID = "group.com.brianklauer.briankeys"
private let personalKey = "bk_personal_v1"

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
                Button("Agregar") { add() }
                    .buttonStyle(.borderedProminent)
                    .disabled(newWord.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)

            if drawerMissing {
                Text("No se pudo abrir el cajón compartido en esta instalación. Avísale a Muse.")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }

            if words.isEmpty {
                Text("Todavía no hay palabras tuyas. Agrega la primera arriba, o fija una desde el teclado con long-press en una sugerencia (📌).")
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

            Text("Desliza una palabra hacia la izquierda para borrarla. Prueba del cajón: agrega una palabra aquí y fíjate si el teclado te la sugiere.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding(.top)
        .navigationTitle("📖 Mi diccionario")
        .onAppear { load() }
    }
}

struct ContentView: View {
    @State private var attempts: [String] = Array(repeating: "", count: testTexts.count)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("BrianKeys")
                            .font(.title2)
                            .bold()
                        // v0.4 (Brian): the version sits right of the title so
                        // he can confirm at a glance what is installed.
                        Text("v0.8")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text("Actívalo en Ajustes → General → Teclado → Teclados → BrianKeysTest, y no olvides «Permitir acceso total» (lo necesitan los haptics).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // v0.8 (Brian): his personal dictionary lives here in
                    // the app — add and delete words without opening the
                    // keyboard panel.
                    NavigationLink {
                        DictionaryView()
                    } label: {
                        HStack {
                            Text("📖 Mi diccionario personal")
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

                    Text("Textos de prueba")
                        .font(.title3)
                        .bold()

                    Text("Escribe cada texto lo más rápido que puedas, aquí mismo con BrianKeys. NO corrijas los typos: los typos son los datos. Al final, «Copiar TODO» y me lo pegas en el chat de una sola vez.")
                        .font(.body)

                    HStack {
                        Button("📋 Copiar TODO") {
                            var parts = ["BrianKeys — resultados de la suite"]
                            for i in testTexts.indices where !attempts[i].isEmpty {
                                parts.append("\(i + 1). Meta: \(testTexts[i])\n   Intento: \(attempts[i])")
                            }
                            UIPasteboard.general.string = parts.joined(separator: "\n")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(attempts.allSatisfy { $0.isEmpty })

                        Button("Borrar todo") {
                            attempts = Array(repeating: "", count: testTexts.count)
                        }
                        .buttonStyle(.bordered)
                        .disabled(attempts.allSatisfy { $0.isEmpty })
                    }

                    ForEach(testTexts.indices, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(i + 1). \(testTexts[i])")
                                .font(.headline)

                            TextField("Tu intento…", text: $attempts[i], axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(2...5)
                                // The test must measure BrianKeys alone, so the
                                // field itself neither corrects nor capitalises.
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)

                            HStack {
                                Button("Copiar intento 📋") {
                                    UIPasteboard.general.string = attempts[i]
                                }
                                .buttonStyle(.bordered)
                                .disabled(attempts[i].isEmpty)

                                Button("Borrar") {
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
