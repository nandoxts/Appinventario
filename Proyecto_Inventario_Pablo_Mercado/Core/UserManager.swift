//
//  UserManager.swift
//  
//
//  Created by Invitado on 16/12/25.
//

import Foundation

final class UserManager {

    static let shared = UserManager()
    private init() {}

    private var users: [AppUser] = []
    private let defaults = UserDefaults.standard

    // MARK: - Persistencia
    private func load() {
        guard let data = defaults.data(forKey: Constants.usersStore),
              let decoded = try? JSONDecoder().decode([AppUser].self, from: data) else {
            users = []
            return
        }
        users = decoded
    }

    private func save() {
        let data = try? JSONEncoder().encode(users)
        defaults.set(data, forKey: Constants.usersStore)
    }

    // MARK: - Estado
    func hasUsers() -> Bool {
        load()
        return !users.isEmpty
    }

    func allUsers() -> [AppUser] {
        load()
        return users
    }

    func currentRole() -> UserRole {
        let raw = defaults.string(forKey: Constants.role) ?? UserRole.worker.rawValue
        return UserRole(rawValue: raw) ?? .worker
    }

    // MARK: - Auth
    func login(email: String, password: String) -> Bool {
        load()
        guard let user = users.first(where: {
            $0.email.lowercased() == email.lowercased() && $0.password == password
        }) else { return false }

        defaults.set(user.id.uuidString, forKey: Constants.userId)
        defaults.set(user.name, forKey: Constants.username)
        defaults.set(user.email, forKey: Constants.email)
        defaults.set(user.role.rawValue, forKey: Constants.role)
        return true
    }

    func logout() {
        defaults.removeObject(forKey: Constants.userId)
        defaults.removeObject(forKey: Constants.username)
        defaults.removeObject(forKey: Constants.email)
        defaults.removeObject(forKey: Constants.role)
    }

    // MARK: - CRUD
    func createUser(name: String, email: String, password: String, role: UserRole) -> Result<Void, String> {
        load()

        guard !name.isEmpty else { return .failure("Nombre inválido") }
        guard email.contains("@") else { return .failure("Correo inválido") }
        guard password.count >= 4 else { return .failure("Contraseña muy corta") }

        if users.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            return .failure("El correo ya existe")
        }

        users.append(AppUser(
            id: UUID(),
            name: name,
            email: email.lowercased(),
            password: password,
            role: role
        ))
        save()
        return .success(())
    }

    func deleteUser(id: UUID) {
        load()
        users.removeAll { $0.id == id }
        save()
    }
}
