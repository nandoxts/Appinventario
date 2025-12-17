import UIKit

class UserListViewController: UIViewController {

    private var users: [AppUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Usuarios"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addUser)
        )
        reload()
    }

    private func reload() {
        users = UserManager.shared.allUsers()
    }

    @objc private func addUser() {
        let vc = UserFormViewController { self.reload() }
        navigationController?.pushViewController(vc, animated: true)
    }
}
