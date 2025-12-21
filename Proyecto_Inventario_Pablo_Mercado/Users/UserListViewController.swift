import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    private var users: [AppUser] = []
    private var filteredUsers: [AppUser] = []
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let emptyStateView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Usuarios"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addUser)
        )

        setupSearchBar()
        setupTable()
        setupEmptyState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Buscar usuario..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTable() {
        // Configurar tabla
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupEmptyState() {
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "person.2")
        iconView.tintColor = .systemGray3
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "No hay usuarios"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemGray
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Presiona + para agregar el primero"
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .systemGray2
        subtitleLabel.font = .systemFont(ofSize: 14)
        
        emptyStateView.axis = .vertical
        emptyStateView.spacing = 12
        emptyStateView.alignment = .center
        emptyStateView.addArrangedSubview(iconView)
        emptyStateView.addArrangedSubview(titleLabel)
        emptyStateView.addArrangedSubview(subtitleLabel)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 80),
            iconView.heightAnchor.constraint(equalToConstant: 80),
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func updateEmptyState() {
        emptyStateView.isHidden = !filteredUsers.isEmpty
        tableView.isHidden = filteredUsers.isEmpty
    }

    private func reload() {
        users = UserManager.shared.allUsers()
        filteredUsers = users
        tableView.reloadData()
        updateEmptyState()
    }

    @objc private func addUser() {
        let vc = UserFormViewController { [weak self] in
            self?.reload()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.configure(user: filteredUsers[indexPath.row])
        return cell
    }

    // Opcional: para mejorar apariencia
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let user = filteredUsers[indexPath.row]

        let sheet = UIAlertController(
            title: user.name,
            message: nil,
            preferredStyle: .actionSheet
        )

        sheet.addAction(UIAlertAction(title: "Editar", style: .default) { [weak self] _ in
            self?.editUser(user)
        })

        sheet.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.confirmDelete(user)
        })

        sheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

        present(sheet, animated: true)
    }


    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { user in
                user.name.lowercased().contains(searchText.lowercased()) ||
                user.email.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
        updateEmptyState()
        updateSearchPlaceholder()
    }
    
    private func updateSearchPlaceholder() {
        if searchBar.text?.isEmpty ?? true {
            searchBar.placeholder = "Buscar usuario..."
        } else {
            searchBar.placeholder = "\(filteredUsers.count) de \(users.count) usuarios"
        }
    }
    
    private func confirmDelete(_ user: AppUser) {
        let alert = UIAlertController(
            title: "Eliminar usuario",
            message: "¿Seguro que deseas eliminar a \(user.name)?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            UserManager.shared.deleteUser(id: user.id)
            self?.reload()
        })

        present(alert, animated: true)
    }
    private func editUser(_ user: AppUser) {
        let vc = UserFormViewController(user: user) { [weak self] in
            self?.reload()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}
