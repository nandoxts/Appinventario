import UIKit

extension UITextField {

    static func form(
        placeholder: String,
        keyboard: UIKeyboardType = .default,
        isSecure: Bool = false
    ) -> UITextField {

        let tf = UITextField()
        tf.placeholder = placeholder
        tf.keyboardType = keyboard
        tf.isSecureTextEntry = isSecure
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no

        tf.backgroundColor = .secondarySystemBackground
        tf.layer.cornerRadius = 12
        tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 15)

        tf.setLeftPadding(14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true

        return tf
    }

    func setLeftPadding(_ value: CGFloat) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 0))
        leftView = view
        leftViewMode = .always
    }
}
