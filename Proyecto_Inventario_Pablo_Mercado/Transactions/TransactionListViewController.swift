import UIKit

class TransactionListViewController: UIViewController, UISearchBarDelegate {

    private let viewModel = TransactionViewModel()
    private var transactionTable: TransactionTableView!
    private let searchBar = UISearchBar()
    private let emptyLabel = UILabel()
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
        emptyLabel.text = "No hay movimientos"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .systemGray
        emptyLabel.font = .systemFont(ofSize: 16)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func updateEmptyState() {
        emptyLabel.isHidden = !filteredTransactions.isEmpty
        transactionTable.isHidden = filteredTransactions.isEmpty
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
    }
}
