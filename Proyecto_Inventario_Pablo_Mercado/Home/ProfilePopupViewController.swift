import UIKit

class ProfilePopupViewController: UIViewController {

    private var username: String
    private var email: String
    private let profileImage: UIImage?

    private var nameLabel: UILabel!
    private var emailLabel: UILabel!

    init(username: String, email: String, profileImage: UIImage? = nil) {
        self.username = username
        self.email = email
        self.profileImage = profileImage
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no implementado") }

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupContainer()
    }

    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    private func setupContainer() {
        view.addSubview(containerView)

        let imageView = UIImageView(image: profileImage ?? UIImage(systemName: "person.circle.fill"))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        nameLabel = UILabel()
        nameLabel.text = username
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textAlignment = .center

        emailLabel = UILabel()
        emailLabel.text = email
        emailLabel.font = .systemFont(ofSize: 16)
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center

        let editButton = UIButton(type: .system)
        editButton.setTitle("Editar perfil", for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)

        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Cerrar sesión", for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 12
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        // Botón de cerrar “X” en la esquina superior derecha
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        closeButton.tintColor = .secondaryLabel
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, emailLabel, editButton, logoutButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stack)
        containerView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),

            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func editTapped() {
        let alert = UIAlertController(title: "Editar perfil", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.text = self.username }
        alert.addTextField { $0.text = self.email }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Guardar", style: .default, handler: { _ in
            let newUsername = alert.textFields?[0].text ?? self.username
            let newEmail = alert.textFields?[1].text ?? self.email

            UserDefaults.standard.set(newUsername, forKey: "username")
            UserDefaults.standard.set(newEmail, forKey: "email")

            self.username = newUsername
            self.email = newEmail
            self.nameLabel.text = newUsername
            self.emailLabel.text = newEmail

            NotificationCenter.default.post(name: NSNotification.Name("ProfileUpdated"), object: nil)
        }))
        present(alert, animated: true)
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func logoutTapped() {
        UserManager.shared.logout()

        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            sceneDelegate.window?.rootViewController = nav
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
