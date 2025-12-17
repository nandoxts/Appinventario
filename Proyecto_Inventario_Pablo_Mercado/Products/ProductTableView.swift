import UIKit

class ProductTableView: UITableView, UITableViewDataSource {

    private var products: [Product] = []

    init(products: [Product]) {
        super.init(frame: .zero, style: .plain)
        self.products = products
        self.dataSource = self
        self.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        self.separatorStyle = .none
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError() }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configure(product: products[indexPath.row])
        return cell
    }

    func update(products: [Product]) {
        self.products = products
        reloadData()
    }
}
