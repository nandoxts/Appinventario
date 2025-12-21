import UIKit

class ProfilePopupViewController: UIViewController {

    private var username: String
    private var email: String
    private let profileImage: UIImage?

    private var nameLabel: UILabel!
    private var emailLabel: UILabel!
    private var roleLabel: UILabel!

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
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupContainer()
    }

    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }

    private func setupContainer() {
        view.addSubview(containerView)

        // Avatar con borde
        let avatarContainer = UIView()
        avatarContainer.backgroundColor = .systemGray6
        avatarContainer.layer.cornerRadius = 50
        avatarContainer.layer.borderWidth = 3
        avatarContainer.layer.borderColor = UIColor.systemBlue.cgColor
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: profileImage ?? UIImage(systemName: "person.circle.fill"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 47
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarContainer.addSubview(imageView)

        // Labels de información
        nameLabel = UILabel()
        nameLabel.text = username
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center

        emailLabel = UILabel()
        emailLabel.text = email
        emailLabel.font = .systemFont(ofSize: 15)
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center
        
        roleLabel = UILabel()
        let currentRole = UserManager.shared.currentRole()
        roleLabel.text = currentRole.displayName
        roleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        roleLabel.textColor = .systemBlue
        roleLabel.textAlignment = .center
        roleLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        roleLabel.layer.cornerRadius = 12
        roleLabel.clipsToBounds = true
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Separador
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false

        // Botón editar perfil
        let editButton = createActionButton(
            title: "Editar Perfil",
            icon: "pencil.circle.fill",
            backgroundColor: .systemBlue,
            action: #selector(editTapped)
        )

        // Botón cerrar sesión
        let logoutButton = createActionButton(
            title: "Cerrar Sesion",
            icon: "arrow.right.circle.fill",
            backgroundColor: .systemRed,
            action: #selector(logoutTapped)
        )

        // Botón cerrar X
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .secondaryLabel
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        let infoStack = UIStackView(arrangedSubviews: [nameLabel, emailLabel, roleLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 6
        infoStack.alignment = .center
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStack = UIStackView(arrangedSubviews: [editButton, logoutButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(avatarContainer)
        containerView.addSubview(infoStack)
        containerView.addSubview(separator)
        containerView.addSubview(buttonStack)
        containerView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            // Container
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 340),
            
            // Avatar container
            avatarContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            avatarContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avatarContainer.widthAnchor.constraint(equalToConstant: 100),
            avatarContainer.heightAnchor.constraint(equalToConstant: 100),
            
            // Avatar image
            imageView.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 94),
            imageView.heightAnchor.constraint(equalToConstant: 94),
            
            // Info stack
            infoStack.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 20),
            infoStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Role label
            roleLabel.heightAnchor.constraint(equalToConstant: 24),
            roleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Separator
            separator.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            // Button stack
            buttonStack.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            buttonStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            
            // Close button
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func createActionButton(title: String, icon: String, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        
        // Configuración
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: icon)
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        
        button.configuration = config
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }

    @objc private func editTapped() {
        let alert = UIAlertController(title: "Editar perfil", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.text = self.username; $0.placeholder = "Nombre" }
        alert.addTextField { $0.text = self.email; $0.placeholder = "Correo"; $0.keyboardType = .emailAddress }
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
        let alert = UIAlertController(
            title: "Cerrar Sesion",
            message: "Seguro que deseas cerrar tu sesion?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Cerrar", style: .destructive) { [weak self] _ in
            UserManager.shared.logout()

            if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                let loginVC = LoginViewController()
                let nav = UINavigationController(rootViewController: loginVC)
                sceneDelegate.window?.rootViewController = nav
                sceneDelegate.window?.makeKeyAndVisible()
            }
        })
        
        present(alert, animated: true)
    }
}
