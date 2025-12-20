import UIKit

class TransactionFormViewController: UIViewController {

    private let viewModel = TransactionViewModel()
    private let productPicker = UIPickerView()
    private let quantityTF = UITextField()
    private let typeSegment = UISegmentedControl(items: ["Entrada", "Salida"])
    private let saveButton = UIButton(type: .system)
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva Transacción"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        // Configuración del campo cantidad
        quantityTF.placeholder = "Cantidad"
        quantityTF.borderStyle = .roundedRect
        quantityTF.keyboardType = .numberPad

        // Configuración del segmento tipo
        typeSegment.selectedSegmentIndex = 0

        // Botón guardar
        saveButton.setTitle("Guardar", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        // Configuración del picker
        productPicker.dataSource = self
        productPicker.delegate = self

        // Stack vertical
        let stack = UIStackView(arrangedSubviews: [
            productPicker,
            quantityTF,
            typeSegment,
            saveButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            productPicker.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    @objc private func saveTapped() {
        // Validar cantidad
        guard let quantityText = quantityTF.text, let quantity = Int(quantityText), quantity > 0 else {
            presentAlert(message: "Cantidad inválida")
            return
        }

        let type: TransactionType = typeSegment.selectedSegmentIndex == 0 ? .entrada : .salida

        let result = viewModel.createTransaction(
            productIndex: selectedIndex,
            quantity: quantity,
            type: type
        )

        switch result {
        case .success:
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

// MARK: - UIPickerView
extension TransactionFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.products.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let product = viewModel.products[row]
        return "\(product.name) (\(product.stock))"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
}
