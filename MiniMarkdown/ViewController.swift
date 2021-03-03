import UIKit

enum Style: CustomStringConvertible {
    case none
    case bold(Int)
    case italics(Int)
    case strikeThrough(Int)
    case underline(Int)

    var description: String {
        switch self {
        case .none:
            return ""
        case .bold(let position):
            return "Bold starting \(position)"
        case .italics(let position):
            return "Italics starting \(position)"
        case .strikeThrough(let position):
            return "StrikeThrough starting \(position)"
        case .underline(let position):
            return "Underline starting \(position)"
        }
    }
}

class MyViewController : UIViewController, UITextViewDelegate {
    var currentStyle: Style = .none

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        return textView
    }()

    lazy var debugLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.addSubview(textView)
        view.addSubview(debugLabel)
        NSLayoutConstraint.activate([
            debugLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3),
            debugLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: debugLabel.trailingAnchor, multiplier: 3),
            textView.topAnchor.constraint(equalToSystemSpacingBelow: debugLabel.topAnchor, multiplier: 3),
            textView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: textView.trailingAnchor, multiplier: 3),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: textView.bottomAnchor, multiplier: 3),
        ])
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var shouldEnterText = true
        switch (text, currentStyle) {
        case ("*", .bold(let start)):
            applyBold(textView: textView, start: start, end: range.location)
            currentStyle = .none
            shouldEnterText = false
        case ("*", .none):
            currentStyle = .bold(range.location)
        case ("_", .italics(let start)):
            applyItalics(textView: textView, start: start, end: range.location)
            currentStyle = .none
            shouldEnterText = false
        case ("_", .none):
            currentStyle = .italics(range.location)
        case ("~", .strikeThrough(let start)):
            applyStrikeThrough(textView: textView, start: start, end: range.location)
            currentStyle = .none
            shouldEnterText = false
        case ("~", .none):
            currentStyle = .strikeThrough(range.location)
        case ("", _):
            let disjoint = Set("*_~").isDisjoint(with: Set(textView.attributedText.attributedSubstring(from: range).string))
            if !disjoint {
                currentStyle = .none
            }
        default:
            break
        }
        debugLabel.text = currentStyle.description
        return shouldEnterText
    }

    func applyBold(textView: UITextView, start: Int, end: Int) {
        let appliedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]
        applyAttribute(textView, appliedAttributes, start: start, end: end)
    }

    func applyItalics(textView: UITextView, start: Int, end: Int) {
        let appliedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 12)
        ]
        applyAttribute(textView, appliedAttributes, start: start, end: end)
    }

    func applyStrikeThrough(textView: UITextView, start: Int, end: Int) {
        let appliedAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]
        applyAttribute(textView, appliedAttributes, start: start, end: end)
    }

    func applyAttribute(_ textView: UITextView, _ attributes: [NSAttributedString.Key: Any], start: Int, end: Int) {
        let range = NSRange(location: start + 1, length: end - start - 1)
        let stringToBold = textView.attributedText.attributedSubstring(from: range).string
        let unTouchedRange = NSRange(location: 0, length: start)
        let unTouchedText = textView.attributedText.attributedSubstring(from: unTouchedRange)
        let boldedText = NSAttributedString(string: stringToBold, attributes: attributes)
        let finalText = NSMutableAttributedString(attributedString: unTouchedText)
        finalText.append(boldedText)
        textView.attributedText = finalText
        let typingAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        textView.typingAttributes = typingAttributes
    }
}
