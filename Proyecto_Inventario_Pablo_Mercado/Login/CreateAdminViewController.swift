import UIKit

class CreateAdminViewController: UIViewController {

    let nameTF = UITextField.form(placeholder: "Nombre")
    let emailTF = UITextField.form(placeholder: "Correo")
    let passTF = UITextField.form(placeholder: "Contraseña", isSecure: true)
    let saveBtn = UIButton.primary(title: "Crear Administrador")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin inicial"
        view.backgroundColor = .systemBackground

        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nameTF, emailTF, passTF, saveBtn])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    @objc private func save() {
        let result = UserManager.shared.createUser(
            name: nameTF.text ?? "",
            email: emailTF.text ?? "",
            password: passTF.text ?? "",
            role: .admin
        )

        switch result {
        case .success:
            navigationController?.popViewController(animated: true)
        case .failure(let msg):
            showAlert(msg)
        }
    }
}
