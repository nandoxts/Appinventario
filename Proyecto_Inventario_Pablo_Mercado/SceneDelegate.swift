//
//  SceneDelegate.swift
//  Proyecto_Inventario_Pablo_Mercado
//
//  Created by DESIGN on 15/12/25.
//

import UIKit

// MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        // Arranque centralizado de la app
        setRoot(.splash)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

//
// MARK: - App Flow centralizado
//

enum AppFlow {
    case splash
    case login
    case createAdmin
    case home
}

extension SceneDelegate {

    /// Cambia el rootViewController de forma segura
    func setRoot(_ flow: AppFlow) {

        let rootVC: UIViewController

        switch flow {

        case .splash:
            rootVC = SplashViewController()

        case .login:
            rootVC = UINavigationController(
                rootViewController: LoginViewController()
            )

        case .createAdmin:
            rootVC = UINavigationController(
                rootViewController: CreateAdminViewController()
            )

        case .home:
            rootVC = UINavigationController(
                rootViewController: HomeViewController()
            )
        }

        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}

