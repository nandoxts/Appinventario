import UIKit

class ProductListViewController: UIViewController, UISearchBarDelegate, ProductTableViewDelegate {

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
        productTable.productDelegate = self // Configurar delegate
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
        
        let form = ProductFormViewController { [weak self] in
            self?.reload()
        }
        navigationController?.pushViewController(form, animated: true)
    }
    
    private func reload() {
        filteredProducts = viewModel.products
        productTable.update(products: filteredProducts)
        updateEmptyState()
    }

    // MARK: - ProductTableViewDelegate
    
    func productTableView(_ tableView: ProductTableView, didSelectProduct product: Product) {
        // Mostrar menú de opciones
        let sheet = UIAlertController(
            title: product.name,
            message: "Precio: $\(product.price) | Stock: \(product.stock)",
            preferredStyle: .actionSheet
        )
        
        if isAdmin() {
            sheet.addAction(UIAlertAction(title: "Editar", style: .default) { [weak self] _ in
                self?.editProduct(product)
            })
            
            sheet.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
                self?.confirmDelete(product)
            })
        }
        
        sheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(sheet, animated: true)
    }
    
    private func editProduct(_ product: Product) {
        if !requireAdmin() { return }
        
        let form = ProductFormViewController(product: product) { [weak self] in
            self?.reload()
        }
        navigationController?.pushViewController(form, animated: true)
    }
    
    private func confirmDelete(_ product: Product) {
        let alert = UIAlertController(
            title: "Eliminar producto",
            message: "¿Seguro que deseas eliminar \(product.name)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.deleteProduct(product)
        })
        
        present(alert, animated: true)
    }
    
    private func deleteProduct(_ product: Product) {
        viewModel.deleteProduct(id: product.id) { [weak self] success in
            if success {
                self?.reload()
            } else {
                self?.showError("No se pudo eliminar el producto")
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
