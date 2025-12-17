import UIKit

class ProductListViewController: UIViewController {

    private let viewModel = ProductViewModel()
    private var productTable: ProductTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos"
        view.backgroundColor = .systemGroupedBackground
        setupTable()
        setupAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Actualizamos la tabla cada vez que la vista aparezca
        productTable.update(products: viewModel.products)
    }

    private func setupTable() {
        productTable = ProductTableView(products: viewModel.products)
        view.addSubview(productTable)
        productTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addProduct)
        )
    }

    @objc private func addProduct() {
        let form = ProductFormViewController {
            // No necesitamos actualizar la tabla aquí
        }
        navigationController?.pushViewController(form, animated: true)
    }
}
