import UIKit

class TransactionTableView: UITableView, UITableViewDataSource {

    private var transactions: [Transaction] = []

    init(transactions: [Transaction]) {
        super.init(frame: .zero, style: .plain)
        self.transactions = transactions
        dataSource = self
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
}
