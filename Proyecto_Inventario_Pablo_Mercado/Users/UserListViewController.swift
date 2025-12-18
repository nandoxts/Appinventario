import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var users: [AppUser] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Usuarios"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addUser)
        )

        // Configurar tabla
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    private func reload() {
        users = UserManager.shared.allUsers()
        tableView.reloadData()
    }

    @objc private func addUser() {
        let vc = UserFormViewController { [weak self] in
            self?.reload()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }

    // Opcional: para mejorar apariencia
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
