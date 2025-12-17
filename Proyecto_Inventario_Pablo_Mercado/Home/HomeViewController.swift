import UIKit

class HomeViewController: UIViewController {

    // MARK: - UI
    private let welcomeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Inventario"

        setupUI()
        setupProfileButton()
        
        // Escuchar cambios de perfil
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: NSNotification.Name("ProfileUpdated"), object: nil)
    }

    private func setupUI() {
        updateWelcomeLabel()

        // Cards
        let productsCard = DashboardButton(title: "Productos", subtitle: "Gestionar inventario", icon: "cube.box.fill", color: .systemBlue)
        productsCard.addTarget(self, action: #selector(goProducts), for: .touchUpInside)

        let transactionsCard = DashboardButton(title: "Movimientos", subtitle: "Entradas y salidas", icon: "arrow.left.arrow.right", color: .systemGreen)
        transactionsCard.addTarget(self, action: #selector(goTransactions), for: .touchUpInside)

        let reportsCard = DashboardButton(title: "Reportes", subtitle: "Resumen y alertas", icon: "chart.bar.fill", color: .systemOrange)
        reportsCard.addTarget(self, action: #selector(goReports), for: .touchUpInside)

        var cards: [UIView] = [welcomeLabel, productsCard, transactionsCard, reportsCard]
        
        // Mostrar usuarios solo si es admin
        if isAdmin() {
            let usersCard = DashboardButton(title: "Usuarios", subtitle: "Gestionar trabajadores", icon: "person.2.fill", color: .systemPurple)
            usersCard.addTarget(self, action: #selector(goUsers), for: .touchUpInside)
            cards.append(usersCard)
        }
    
        // Stack vertical
        let stack = UIStackView(arrangedSubviews: cards)
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupProfileButton() {
        let profileButton = UIButton(type: .system)
        profileButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        profileButton.layer.cornerRadius = 15
        profileButton.clipsToBounds = true

       
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "user_placeholder")
        config.imagePadding = 0
        config.imagePlacement = .all
        config.baseForegroundColor = nil 

        profileButton.configuration = config

        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)

        let barItem = UIBarButtonItem(customView: profileButton)
        barItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barItem.customView!.widthAnchor.constraint(equalToConstant: 36),
            barItem.customView!.heightAnchor.constraint(equalToConstant: 36)
        ])

        navigationItem.rightBarButtonItem = barItem
    }


    private func updateWelcomeLabel() {
        let username = UserDefaults.standard.string(forKey: "username") ?? "Usuario"
        let role = getCurrentRole().displayName
        welcomeLabel.text = "¡Bienvenido, \(username)!\n(\(role))"
        welcomeLabel.font = .boldSystemFont(ofSize: 20)
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
    }

    @objc private func profileTapped() {
        let username = UserDefaults.standard.string(forKey: "username") ?? "Usuario"
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let profileImage = UIImage(named: "user_placeholder")
        
        let popup = ProfilePopupViewController(username: username, email: email, profileImage: profileImage)
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true)
    }

    @objc private func profileUpdated() {
        updateWelcomeLabel()
    }

    @objc private func logoutTapped() {
        UserManager.shared.logout()
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)

        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    @objc private func goProducts() { navigationController?.pushViewController(ProductListViewController(), animated: true) }
    @objc private func goTransactions() { navigationController?.pushViewController(TransactionListViewController(), animated: true) }
    @objc private func goReports() { navigationController?.pushViewController(ReportsViewController(), animated: true) }
    @objc private func goUsers() { navigationController?.pushViewController(UserListViewController(), animated: true) }
}
