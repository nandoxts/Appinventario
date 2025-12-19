import UIKit

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()
    private var isLoggingIn = false

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
        setupGradientBackground()
        setupUI()

        // ⚠️ Si no hay usuarios, redirigir a crear admin
        if !viewModel.hasUsers() {
            goToCreateAdmin()
        }
    }

    // MARK: - Gradient Background
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        let bounds = UIScreen.main.bounds
        gradientLayer.frame = bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
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

        isLoggingIn = true
        updateLoginButton()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            if self?.viewModel.login(email: email, password: password) ?? false {
                self?.goToHome()
            } else {
                self?.isLoggingIn = false
                self?.updateLoginButton()
                self?.showAlert("Credenciales incorrectas")
            }
        }
    }

    private func updateLoginButton() {
        loginButton.alpha = isLoggingIn ? 0.6 : 1.0
        loginButton.isUserInteractionEnabled = !isLoggingIn
        
        if isLoggingIn {
            loginButton.setTitle("Iniciando...", for: .normal)
        } else {
            loginButton.setTitle("Iniciar sesión", for: .normal)
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

        // Mejorar campos de texto
        emailTF.layer.borderColor = UIColor.systemGray3.cgColor
        emailTF.layer.borderWidth = 1
        emailTF.layer.cornerRadius = 8
        emailTF.clipsToBounds = true
        emailTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        emailTF.leftViewMode = .always

        passwordTF.layer.borderColor = UIColor.systemGray3.cgColor
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.cornerRadius = 8
        passwordTF.clipsToBounds = true
        passwordTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        passwordTF.leftViewMode = .always

        // Mejorar botón
        loginButton.layer.cornerRadius = 8
        loginButton.clipsToBounds = true
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
            emailTF.heightAnchor.constraint(equalToConstant: 48),
            passwordTF.heightAnchor.constraint(equalToConstant: 48),
            loginButton.heightAnchor.constraint(equalToConstant: 48),

            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
