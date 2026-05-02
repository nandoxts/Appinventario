import Foundation

final class UserManagementUseCases {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    var users: [AppUser] { repository.allUsers() }

    func create(name: String, email: String, password: String, role: UserRole) -> Result<Void, UserError> {
        repository.create(name: name, email: email, password: password, role: role)
    }

    func update(id: UUID, name: String, email: String, role: UserRole) -> Result<Void, UserError> {
        repository.update(id: id, name: name, email: email, role: role)
    }

    func delete(id: UUID) {
        repository.delete(id: id)
    }
}
