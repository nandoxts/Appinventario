import Foundation

final class AuthUseCases {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func login(email: String, password: String) -> Bool {
        repository.login(email: email, password: password)
    }

    func logout() {
        repository.logout()
    }

    func currentUser() -> AppUser? {
        repository.currentUser
    }

    func currentRole() -> UserRole {
        repository.currentRole()
    }

    func hasUsers() -> Bool {
        repository.hasUsers()
    }
}
