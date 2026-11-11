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

struct ContentView: View {
    @State private var attempts: [String] = Array(repeating: "", count: testTexts.count)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("BrianKeys")
                    .font(.title2)
                    .bold()

                Text("Actívalo en Ajustes → General → Teclado → Teclados → BrianKeysTest, y no olvides «Permitir acceso total» (lo necesitan los haptics).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Divider()

                Text("Textos de prueba")
                    .font(.title3)
                    .bold()

                Text("Escribe cada texto lo más rápido que puedas, aquí mismo con BrianKeys. NO corrijas los typos: los typos son los datos. Al final, «Copiar intento» y me lo pegas en el chat.")
                    .font(.body)

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
