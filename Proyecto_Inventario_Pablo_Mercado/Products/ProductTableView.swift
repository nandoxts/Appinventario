import UIKit

// Protocolo para delegar acciones de productos
protocol ProductTableViewDelegate: AnyObject {
    func productTableView(_ tableView: ProductTableView, didSelectProduct product: Product)
}

class ProductTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    private var products: [Product] = []
    weak var productDelegate: ProductTableViewDelegate?

    init(products: [Product]) {
        super.init(frame: .zero, style: .plain)
        self.products = products
        self.dataSource = self
        self.delegate = self
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
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products[indexPath.row]
        productDelegate?.productTableView(self, didSelectProduct: product)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
