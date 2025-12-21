import UIKit

protocol TransactionTableViewDelegate: AnyObject {
    func transactionTableView(_ tableView: TransactionTableView, didSelectTransaction transaction: Transaction)
}

class TransactionTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    private var transactions: [Transaction] = []
    weak var transactionDelegate: TransactionTableViewDelegate?

    init(transactions: [Transaction]) {
        super.init(frame: .zero, style: .plain)
        self.transactions = transactions
        dataSource = self
        delegate = self
        register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        separatorStyle = .none
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError() }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.configure(transaction: transactions[indexPath.row])
        return cell
    }

    func update(transactions: [Transaction]) {
        self.transactions = transactions
        reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactions[indexPath.row]
        transactionDelegate?.transactionTableView(self, didSelectTransaction: transaction)
    }
}
