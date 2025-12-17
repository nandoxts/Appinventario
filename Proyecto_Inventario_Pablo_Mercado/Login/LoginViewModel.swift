import Foundation

class LoginViewModel {

    func login(email: String, password: String) -> Bool {
        return UserManager.shared.login(email: email, password: password)
    }
    
    func logout() {
        UserManager.shared.logout()
    }
    
    func hasUsers() -> Bool {
        return UserManager.shared.hasUsers()
    }
}
