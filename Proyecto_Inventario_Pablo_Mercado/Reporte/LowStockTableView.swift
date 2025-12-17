import UIKit

class LowStockTableView: UITableView, UITableViewDataSource {

    private var products: [Product] = []

    init(products: [Product]) {
        super.init(frame: .zero, style: .plain)
        self.products = products
        dataSource = self
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        separatorStyle = .none
        backgroundColor = .clear
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) { fatalError() }

    func update(products: [Product]) {
        self.products = products
        reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = products[indexPath.row]
        cell.textLabel?.text = "• \(product.name) (\(product.stock))"
        cell.textLabel?.textColor = .systemRed
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
}
