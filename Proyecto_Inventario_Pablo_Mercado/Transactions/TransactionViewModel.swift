import Foundation

enum TransactionError: Error {
    case invalidQuantity
    case insufficientStock
    case noProducts

    var localizedDescription: String {
        switch self {
        case .invalidQuantity: return "Cantidad inválida"
        case .insufficientStock: return "No hay suficiente stock"
        case .noProducts: return "No hay productos disponibles"
        }
    }
}

class TransactionViewModel {

    // Acceder a productos
    var products: [Product] {
        DataManager.shared.products
    }

    // Acceder a transacciones
    var transactions: [Transaction] {
        DataManager.shared.transactions
    }

    func createTransaction(productIndex: Int, quantity: Int, type: TransactionType) -> Result<Void, TransactionError> {

        guard products.indices.contains(productIndex) else {
            return .failure(.noProducts)
        }

        let product = products[productIndex]

        guard quantity > 0 else {
            return .failure(.invalidQuantity)
        }

        let transaction = Transaction(
            id: UUID(),
            productId: product.id,
            productName: product.name,
            quantity: quantity,
            type: type,
            date: Date()
        )

        let success = DataManager.shared.addTransaction(transaction)

        if success {
            return .success(())
        } else {
            return .failure(.insufficientStock)
        }
    }
}

