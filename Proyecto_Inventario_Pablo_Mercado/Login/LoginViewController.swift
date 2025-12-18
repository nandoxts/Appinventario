import UIKit

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()

    private let logoImageView = UIImageView()
    private let emailTF = UITextField.form(
        placeholder: "Correo electrónico",
        keyboard: .emailAddress
    )
    private let passwordTF = UITextField.form(
        placeholder: "Contraseña",
        isSecure: true
    )
    private let loginButton = UIButton.primary(title: "Iniciar sesión")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()

        // ⚠️ Si no hay usuarios, redirigir a crear admin
        if !viewModel.hasUsers() {
            goToCreateAdmin()
        }
    }

    // MARK: - Actions

    @objc private func loginTapped() {

        guard
            let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty
        else {
            showAlert("Todos los campos son obligatorios")
            return
        }

        if viewModel.login(email: email, password: password) {
            goToHome()
        } else {
            showAlert("Credenciales incorrectas")
        }
    }

    // MARK: - Navigation (centralizada)

    private func goToHome() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.setRoot(.home)
        }
    }

    private func goToCreateAdmin() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.setRoot(.createAdmin)
        }
    }

    // MARK: - UI

    private func setupUI() {

        logoImageView.image = UIImage(systemName: "cube.box.fill")
        logoImageView.tintColor = .systemBlue
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        loginButton.addTarget(
            self,
            action: #selector(loginTapped),
            for: .touchUpInside
        )

        let stack = UIStackView(arrangedSubviews: [
            logoImageView,
            emailTF,
            passwordTF,
            loginButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 80),

            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
