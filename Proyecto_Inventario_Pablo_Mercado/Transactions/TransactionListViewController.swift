import UIKit

class TransactionListViewController: UIViewController, UISearchBarDelegate, TransactionTableViewDelegate {

    private let viewModel = TransactionViewModel()
    private var transactionTable: TransactionTableView!
    private let searchBar = UISearchBar()
    private let emptyStateView = UIStackView()
    private var filteredTransactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movimientos"
        view.backgroundColor = .systemGroupedBackground
        setupSearchBar()
        setupTable()
        setupEmptyState()
        
        // Solo admin puede agregar transacciones
        if isAdmin() {
            setupAddButton()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredTransactions = viewModel.transactions
        transactionTable.update(transactions: filteredTransactions)
        updateEmptyState()
        updateSearchPlaceholder()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Buscar movimiento..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTable() {
        filteredTransactions = viewModel.transactions
        transactionTable = TransactionTableView(transactions: filteredTransactions)
        transactionTable.transactionDelegate = self // Configurar delegate
        view.addSubview(transactionTable)
        transactionTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            transactionTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            transactionTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupEmptyState() {
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "arrow.left.arrow.right")
        iconView.tintColor = .systemGray3
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "No hay movimientos"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemGray
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = isAdmin() ? "Presiona + para registrar el primero" : "A\u00fan no hay transacciones registradas"
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
        emptyStateView.isHidden = !filteredTransactions.isEmpty
        transactionTable.isHidden = filteredTransactions.isEmpty
    }

    private func updateSearchPlaceholder() {
        let total = viewModel.transactions.count
        let showing = filteredTransactions.count
        
        if searchBar.text?.isEmpty ?? true {
            searchBar.placeholder = "Buscar movimiento..."
        } else {
            searchBar.placeholder = "\(showing) de \(total) movimientos"
        }
    }

    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTransaction)
        )
    }

    @objc private func addTransaction() {
        if !requireAdmin() { return }
        let formVC = TransactionFormViewController()
        navigationController?.pushViewController(formVC, animated: true)
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTransactions = viewModel.transactions
        } else {
            filteredTransactions = viewModel.transactions.filter { transaction in
                transaction.productName.lowercased().contains(searchText.lowercased())
            }
        }
        transactionTable.update(transactions: filteredTransactions)
        updateEmptyState()
        updateSearchPlaceholder()
    }

    // MARK: - TransactionTableViewDelegate
    
    func transactionTableView(_ tableView: TransactionTableView, didSelectTransaction transaction: Transaction) {
        // Mostrar menú de opciones
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        let sheet = UIAlertController(
            title: transaction.productName,
            message: "\(transaction.type == .entrada ? "Entrada" : "Salida") de \(transaction.quantity) unidades\n\(formatter.string(from: transaction.date))",
            preferredStyle: .actionSheet
        )
        
        if isAdmin() {
            sheet.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
                self?.confirmDelete(transaction)
            })
        }
        
        sheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(sheet, animated: true)
    }
    
    private func confirmDelete(_ transaction: Transaction) {
        let alert = UIAlertController(
            title: "Eliminar transacción",
            message: "¿Seguro que deseas eliminar esta transacción? Se revertirá el cambio en el stock del producto.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.deleteTransaction(transaction)
        })
        
        present(alert, animated: true)
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        viewModel.deleteTransaction(transaction) { [weak self] success in
            if success {
                self?.reload()
            } else {
                self?.showAlert("Error al eliminar la transacción")
            }
        }
    }
    
    private func reload() {
        filteredTransactions = viewModel.transactions
        transactionTable.update(transactions: filteredTransactions)
        updateEmptyState()
        updateSearchPlaceholder()
    }
}
