import UIKit

class ProductFormViewController: UIViewController {

    private let viewModel = ProductViewModel()
    private let completion: () -> Void

    private let nameTF = UITextField()
    private let priceTF = UITextField()
    private let stockTF = UITextField()
    private let categoryPicker = UIPickerView()
    private var selectedCategory: ProductCategory = .other

    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no implementado") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nuevo Producto"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        nameTF.placeholder = "Nombre"
        nameTF.borderStyle = .roundedRect

        priceTF.placeholder = "Precio"
        priceTF.borderStyle = .roundedRect
        priceTF.keyboardType = .decimalPad

        stockTF.placeholder = "Stock"
        stockTF.borderStyle = .roundedRect
        stockTF.keyboardType = .numberPad

        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Guardar", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            nameTF,
            priceTF,
            stockTF,
            categoryPicker,
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

    @objc private func saveTapped() {
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
