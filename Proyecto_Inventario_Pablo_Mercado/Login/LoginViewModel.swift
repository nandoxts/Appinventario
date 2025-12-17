import Foundation

class LoginViewModel {

    private let validEmail = "admin@demo.com"
    private let validPassword = "123456"
    private let username = "Admin"

    func login(email: String, password: String) -> Bool {
        if email == validEmail && password == validPassword {
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(email, forKey: "email")  // <-- esta línea faltaba
            return true
        }

        return false
    }
}
