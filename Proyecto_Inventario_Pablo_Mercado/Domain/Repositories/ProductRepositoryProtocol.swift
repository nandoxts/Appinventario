import Foundation

enum ProductError: Error, LocalizedError {
    case invalidName
    case invalidPrice
    case invalidStock
    case notFound

    var errorDescription: String? {
        switch self {
        case .invalidName: return "Nombre inválido"
        case .invalidPrice: return "Precio inválido"
        case .invalidStock: return "Stock inválido"
        case .notFound: return "Producto no encontrado"
        }
    }
}

protocol ProductRepositoryProtocol {
    var products: [Product] { get }
    @discardableResult func add(_ product: Product) -> Bool
    @discardableResult func update(_ product: Product) -> Bool
    func delete(id: Int, completion: @escaping (Bool) -> Void)
    func find(by id: Int) -> Product?
}
