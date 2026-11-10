import SwiftUI

struct ContentView: View {
    @State private var testText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("BrianKeys — pipeline test")
                .font(.title2)
                .bold()

            Text("This tiny app exists for one reason: to prove we can build a keyboard on Berenice (Windows), compile it on a borrowed cloud Mac, and install it on this iPhone — no Mac of our own.")
                .font(.body)

            Text("Turn it on: Settings → General → Keyboard → Keyboards → Add New Keyboard → BrianKeysTest")
                .font(.body)
                .bold()

            Text("Then tap the field below, switch to BrianKeys with the globe key, and type a sentence.")
                .font(.body)

            TextField("Tap here and type with BrianKeys…", text: $testText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)

            Spacer()
        }
        .padding()
    }
}
