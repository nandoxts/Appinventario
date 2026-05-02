import Foundation

protocol UserRepositoryProtocol {
    var currentUser: AppUser? { get }
    func allUsers() -> [AppUser]
    func currentRole() -> UserRole
    func hasUsers() -> Bool
    func login(email: String, password: String) -> Bool
    func logout()
    func create(name: String, email: String, password: String, role: UserRole) -> Result<Void, UserError>
    func update(id: UUID, name: String, email: String, role: UserRole) -> Result<Void, UserError>
    func delete(id: UUID)
}
