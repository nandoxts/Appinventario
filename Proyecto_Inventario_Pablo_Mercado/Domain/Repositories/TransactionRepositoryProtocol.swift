import Foundation

enum TransactionError: Error, LocalizedError {
    case invalidQuantity
    case insufficientStock
    case noProducts
    case productNotFound

    var errorDescription: String? {
        switch self {
        case .invalidQuantity: return "Cantidad inválida"
        case .insufficientStock: return "Stock insuficiente"
        case .noProducts: return "No hay productos disponibles"
        case .productNotFound: return "Producto no encontrado"
        }
    }
}

protocol TransactionRepositoryProtocol {
    var transactions: [Transaction] { get }
    @discardableResult func add(_ transaction: Transaction) -> Bool
    @discardableResult func delete(id: String) -> Bool
}
