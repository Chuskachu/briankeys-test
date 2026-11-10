import UIKit

/// BrianKeys — pipeline proof-test keyboard.
/// Deliberately minimal: three letter rows + one bottom row.
/// Big, well-separated keys on purpose (44pt tall) — this is a test of the
/// BUILD PIPELINE, not the final design.
class KeyboardViewController: UIInputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fixed keyboard height for the test (220pt).
        let height = NSLayoutConstraint(item: view!, attribute: .height,
                                        relatedBy: .equal, toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: 220)
        height.priority = UILayoutPriority(999)
        view.addConstraint(height)

        let rows: [[String]] = [
            ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
            ["Z", "X", "C", "V", "B", "N", "M"]
        ]

        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4)
        ])

        for letters in rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 5
            for letter in letters {
                rowStack.addArrangedSubview(makeKey(title: letter, action: #selector(keyTapped(_:))))
            }
            stack.addArrangedSubview(rowStack)
        }

        // Bottom row: globe | SPACE (wide) | delete | return
        let bottom = UIStackView()
        bottom.axis = .horizontal
        bottom.distribution = .fill
        bottom.spacing = 5

        let globe = makeKey(title: "🌐", action: #selector(handleInputModeList(from:with:)))
        globe.widthAnchor.constraint(equalToConstant: 44).isActive = true
        bottom.addArrangedSubview(globe)

        bottom.addArrangedSubview(makeKey(title: "space", action: #selector(spaceTapped)))

        let del = makeKey(title: "⌫", action: #selector(deleteTapped))
        del.widthAnchor.constraint(equalToConstant: 56).isActive = true
        bottom.addArrangedSubview(del)

        let ret = makeKey(title: "⏎", action: #selector(returnTapped))
        ret.widthAnchor.constraint(equalToConstant: 56).isActive = true
        bottom.addArrangedSubview(ret)

        stack.addArrangedSubview(bottom)
    }

    private func makeKey(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 6
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func keyTapped(_ sender: UIButton) {
        guard let letter = sender.title(for: .normal) else { return }
        textDocumentProxy.insertText(letter.lowercased())
    }

    @objc private func spaceTapped() {
        textDocumentProxy.insertText(" ")
    }

    @objc private func deleteTapped() {
        textDocumentProxy.deleteBackward()
    }

    @objc private func returnTapped() {
        textDocumentProxy.insertText("\n")
    }
}
