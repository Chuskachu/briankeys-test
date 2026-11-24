import SwiftUI

// v0.34i (Brian): the emoji names page — every emoji with its
// official name in Spanish and English, searchable. These are
// the very names the keyboard's emoji chip answers to: type the
// word while writing and the emoji offers itself. Tap a row to
// copy the emoji.
struct EmojiNamesView: View {
    @State private var query = ""
    @State private var copied: String? = nil

    private func fold(_ s: String) -> String {
        s.lowercased().folding(options: .diacriticInsensitive, locale: nil)
    }

    private var rows: [(emoji: String, es: String, en: String)] {
        let all = EmojiNameData.all
        let q = fold(query.trimmingCharacters(in: .whitespaces))
        guard !q.isEmpty else { return all }
        return all.filter { fold($0.es).contains(q) || fold($0.en).contains(q) }
    }

    var body: some View {
        List(rows, id: \.emoji) { row in
            HStack(spacing: 12) {
                Text(row.emoji)
                    .font(.system(size: 30))
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.es.isEmpty ? row.en : row.es)
                        .font(.body)
                    if !row.en.isEmpty && row.en != row.es {
                        Text(row.en)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                if copied == row.emoji {
                    Text("✓ Copiado")
                        .font(.footnote)
                        .foregroundStyle(.green)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIPasteboard.general.string = row.emoji
                copied = row.emoji
            }
        }
        .listStyle(.plain)
        .searchable(text: $query, prompt: "Busca un emote: nerd, gato, corazón…")
        .navigationTitle("🔤 Emoji names")
    }
}
