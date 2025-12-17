import UIKit

class TransactionListViewController: UIViewController {

    private let viewModel = TransactionViewModel()
    private var transactionTable: TransactionTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movimientos"
        view.backgroundColor = .systemGroupedBackground

        setupTable()
        
        // Solo admin puede agregar transacciones
        if isAdmin() {
            setupAddButton()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transactionTable.update(transactions: viewModel.transactions)
    }

    private func setupTable() {
        transactionTable = TransactionTableView(transactions: viewModel.transactions)
        view.addSubview(transactionTable)
        transactionTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            transactionTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transactionTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTransaction)
        )
    }

    @objc private func addTransaction() {        if !requireAdmin() { return }
                let formVC = TransactionFormViewController()
        navigationController?.pushViewController(formVC, animated: true)
    }
}
