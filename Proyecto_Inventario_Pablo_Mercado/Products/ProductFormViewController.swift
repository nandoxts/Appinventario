import UIKit

class ProductFormViewController: UIViewController {

    private let viewModel = ProductViewModel()
    private let completion: () -> Void
    private let product: Product? // Producto a editar (nil si es nuevo)

    private let nameTF = UITextField.form(placeholder: "Nombre del producto")
    private let priceTF = UITextField.form(placeholder: "Precio", keyboard: .decimalPad)
    private let stockTF = UITextField.form(placeholder: "Stock inicial", keyboard: .numberPad)
    private let categoryPicker = UIPickerView()
    private var selectedCategory: ProductCategory = .other

    // Inicializador modificado para soportar edición
    init(product: Product? = nil, completion: @escaping () -> Void) {
        self.product = product
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no implementado") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = product == nil ? "Nuevo Producto" : "Editar Producto"
        view.backgroundColor = .systemBackground
        setupUI()
        loadProductData()
    }

    private func setupUI() {
        nameTF.returnKeyType = .next
        priceTF.returnKeyType = .next
        stockTF.returnKeyType = .done

        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        let categoryLabel = UILabel()
        categoryLabel.text = "Categoría"
        categoryLabel.font = .boldSystemFont(ofSize: 15)
        categoryLabel.textColor = .label

        let categoryStack = UIStackView(arrangedSubviews: [categoryLabel, categoryPicker])
        categoryStack.axis = .vertical
        categoryStack.spacing = 8

        let saveButton = UIButton.primary(title: "Guardar")
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            nameTF,
            priceTF,
            stockTF,
            categoryStack,
            saveButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            categoryPicker.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func loadProductData() {
        guard let product = product else { return }
        
        // Llenar campos con datos existentes
        nameTF.text = product.name
        priceTF.text = String(product.price)
        stockTF.text = String(product.stock)
        selectedCategory = product.category
        
        // Seleccionar categoría en picker
        if let index = ProductCategory.allCases.firstIndex(of: product.category) {
            categoryPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }

    @objc private func saveTapped() {
        // Modo edición
        if let existingProduct = product {
            guard let price = Double(priceTF.text ?? ""),
                  let stock = Int(stockTF.text ?? "") else {
                presentAlert(message: "Precio o stock inválido")
                return
            }
            
            let updatedProduct = Product(
                id: existingProduct.id,
                name: nameTF.text ?? "",
                price: price,
                stock: stock,
                category: selectedCategory
            )
            
            viewModel.updateProduct(updatedProduct)
            completion()
            navigationController?.popViewController(animated: true)
            
        } else {
            // Modo creación
            let result = viewModel.addProduct(
                name: nameTF.text ?? "",
                priceText: priceTF.text ?? "",
                stockText: stockTF.text ?? "",
                category: selectedCategory
            )

            switch result {
            case .success:
                completion()
                navigationController?.popViewController(animated: true)
            case .failure(let error):
                presentAlert(message: error.localizedDescription)
            }
        }
    }

    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}

extension ProductFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ProductCategory.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        ProductCategory.allCases[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = ProductCategory.allCases[row]
    }
}
