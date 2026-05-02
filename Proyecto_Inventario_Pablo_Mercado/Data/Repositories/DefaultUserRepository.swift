import Foundation

extension UserManager: UserRepositoryProtocol {
    func create(name: String, email: String, password: String, role: UserRole) -> Result<Void, UserError> {
        createUser(name: name, email: email, password: password, role: role)
    }

    func update(id: UUID, name: String, email: String, role: UserRole) -> Result<Void, UserError> {
        updateUser(id: id, name: name, email: email, role: role)
    }

    func delete(id: UUID) {
        deleteUser(id: id)
    }
}
