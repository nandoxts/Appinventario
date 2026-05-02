import Foundation

final class LoginViewModel {
    private let authUseCases: AuthUseCases

    init(authUseCases: AuthUseCases = AppDependencies.shared.authUseCases) {
        self.authUseCases = authUseCases
    }

    func login(email: String, password: String) -> Bool {
        authUseCases.login(email: email, password: password)
    }

    func logout() {
        authUseCases.logout()
    }

    func hasUsers() -> Bool {
        authUseCases.hasUsers()
    }
}
