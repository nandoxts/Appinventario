import UIKit

class ProductListViewController: UIViewController, UISearchBarDelegate {

    private let viewModel = ProductViewModel()
    private var productTable: ProductTableView!
    private let searchBar = UISearchBar()
    private let emptyLabel = UILabel()
    private var filteredProducts: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos"
        view.backgroundColor = .systemGroupedBackground
        setupSearchBar()
        setupTable()
        setupEmptyState()
        
        // Boton agregar solo para admin
        if isAdmin() {
            setupAddButton()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Actualizamos la tabla cada vez que la vista aparezca
        filteredProducts = viewModel.products
        productTable.update(products: filteredProducts)
        updateEmptyState()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Buscar producto..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTable() {
        filteredProducts = viewModel.products
        productTable = ProductTableView(products: filteredProducts)
        view.addSubview(productTable)
        productTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            productTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupEmptyState() {
        emptyLabel.text = "No hay productos"
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
        emptyLabel.isHidden = !filteredProducts.isEmpty
        productTable.isHidden = filteredProducts.isEmpty
    }

    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addProduct)
        )
    }

    @objc private func addProduct() {
        if !requireAdmin() { return }
        
        let form = ProductFormViewController {
            // No necesitamos actualizar la tabla aquí
        }
        navigationController?.pushViewController(form, animated: true)
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = viewModel.products
        } else {
            filteredProducts = viewModel.products.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
        }
        productTable.update(products: filteredProducts)
        updateEmptyState()
    }
}
