import UIKit

class SplashViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo") // Cambia "logo" por tu asset
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        setupUI()
    }

    private func setupUI() {
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAndTransition()
    }

    private func animateAndTransition() {
        // Escala el logo y luego navega
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut) {
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.logoImageView.alpha = 0.8
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.logoImageView.alpha = 0
            } completion: { _ in
                self.goToLogin()
            }
        }
    }

    private func goToLogin() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

}
