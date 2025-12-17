import UIKit

class UserFormViewController: UIViewController {

    let nameTF = UITextField.form(placeholder: "Nombre")
    let emailTF = UITextField.form(placeholder: "Correo")
    let passTF = UITextField.form(placeholder: "Contraseña", isSecure: true)
    let roleSegment = UISegmentedControl(items: ["Admin", "Trabajador"])
    let saveBtn = UIButton.primary(title: "Guardar")

    let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nuevo Usuario"
        view.backgroundColor = .systemBackground
        roleSegment.selectedSegmentIndex = 1

        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            nameTF, emailTF, passTF, roleSegment, saveBtn
        ])
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
        let role: UserRole = roleSegment.selectedSegmentIndex == 0 ? .admin : .worker

        let result = UserManager.shared.createUser(
            name: nameTF.text ?? "",
            email: emailTF.text ?? "",
            password: passTF.text ?? "",
            role: role
        )

        switch result {
        case .success:
            completion()
            navigationController?.popViewController(animated: true)
        case .failure(let error):
            showAlert(error.localizedDescription)
        }
    }
}
