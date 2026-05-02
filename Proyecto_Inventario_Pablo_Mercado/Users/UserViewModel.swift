import Foundation

final class UserViewModel {
    private let useCases: UserManagementUseCases

    var users: [AppUser] { useCases.users }

    init(useCases: UserManagementUseCases = AppDependencies.shared.userManagementUseCases) {
        self.useCases = useCases
    }

    func create(name: String, email: String, password: String, role: UserRole) -> Result<Void, UserError> {
        useCases.create(name: name, email: email, password: password, role: role)
    }

    func update(id: UUID, name: String, email: String, role: UserRole) -> Result<Void, UserError> {
        useCases.update(id: id, name: name, email: email, role: role)
    }

    func delete(id: UUID) {
        useCases.delete(id: id)
    }
}
