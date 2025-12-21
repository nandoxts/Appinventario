import UIKit

class TransactionFormViewController: UIViewController {

    private let viewModel = TransactionViewModel()
    private let productPicker = UIPickerView()
    private let quantityTF = UITextField.form(placeholder: "Cantidad", keyboard: .numberPad)
    private let typeSegment = UISegmentedControl(items: ["Entrada", "Salida"])
    private let saveButton = UIButton.primary(title: "Guardar")
    private let emailInfoLabel = UILabel()
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva Transacción"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        // Configuración del segmento tipo
        typeSegment.selectedSegmentIndex = 0

        // Botón guardar
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        // Configuración del picker
        productPicker.dataSource = self
        productPicker.delegate = self

        let productLabel = UILabel()
        productLabel.text = "Seleccionar Producto"
        productLabel.font = .boldSystemFont(ofSize: 15)
        productLabel.textColor = .label

        let productStack = UIStackView(arrangedSubviews: [productLabel, productPicker])
        productStack.axis = .vertical
        productStack.spacing = 8

        let typeLabel = UILabel()
        typeLabel.text = "Tipo de Movimiento"
        typeLabel.font = .boldSystemFont(ofSize: 15)
        typeLabel.textColor = .label

        let typeStack = UIStackView(arrangedSubviews: [typeLabel, typeSegment])
        typeStack.axis = .vertical
        typeStack.spacing = 8

        // Email info label
        emailInfoLabel.text = "Se enviará notificación si esta transacción es importante"
        emailInfoLabel.font = .systemFont(ofSize: 12)
        emailInfoLabel.textColor = .systemBlue
        emailInfoLabel.textAlignment = .center
        emailInfoLabel.numberOfLines = 0

        // Stack vertical
        let stack = UIStackView(arrangedSubviews: [
            productStack,
            quantityTF,
            typeStack,
            emailInfoLabel,
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
            presentAlert(title: "Error", message: "Cantidad inválida")
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
            // Mostrar alerta de éxito con opción de saber si se envió email
            let product = viewModel.products[selectedIndex]
            
            var messageText = "Transacción registrada correctamente"
            
            // Determinar si se envió email
            let wasEmailSent = shouldSendEmail(for: quantity, type: type, productStock: product.stock)
            if wasEmailSent {
                messageText += "\nEmail de notificación enviado"
            }
            
            let alert = UIAlertController(title: "Éxito", message: messageText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
            
        case .failure(let error):
            presentAlert(title: "Error", message: error.localizedDescription)
        }
    }

    private func shouldSendEmail(for quantity: Int, type: TransactionType, productStock: Int) -> Bool {
        // Misma lógica que TransactionEmailService
        let largeQuantityThreshold = 50
        let criticalStockThreshold = 5
        
        switch type {
        case .salida:
            // Se envía si es salida grande O si queda stock crítico
            if quantity >= largeQuantityThreshold {
                return true
            }
            let newStock = productStock - quantity
            if newStock >= 0 && newStock <= criticalStockThreshold {
                return true
            }
            return false
        case .entrada:
            // Se envía si la entrada es grande
            return quantity >= largeQuantityThreshold
        }
    }

    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
