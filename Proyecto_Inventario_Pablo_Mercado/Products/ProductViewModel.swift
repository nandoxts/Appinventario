import Foundation

enum ProductError: Error {
    case invalidName
    case invalidPrice
    case invalidStock

    var localizedDescription: String {
        switch self {
        case .invalidName: return "Nombre inválido"
        case .invalidPrice: return "Precio inválido"
        case .invalidStock: return "Stock inválido"
        }
    }
}

class ProductViewModel {

    var products: [Product] {
        DataManager.shared.products
    }

    func addProduct(name: String, priceText: String, stockText: String, category: ProductCategory) -> Result<Void, ProductError> {
        guard !name.isEmpty else { return .failure(.invalidName) }
        guard let price = Double(priceText), price >= 0 else { return .failure(.invalidPrice) }
        guard let stock = Int(stockText), stock >= 0 else { return .failure(.invalidStock) }

        let product = Product(id: 0, name: name, price: price, stock: stock, category: category)
        DataManager.shared.addProduct(product)
        return .success(())
    }

    func updateProduct(_ product: Product) {
        DataManager.shared.updateProduct(product)
    }

    func deleteProduct(id: Int, completion: @escaping (Bool) -> Void) {
        DataManager.shared.deleteProduct(id: id) { success in
            completion(success)
        }
    }

}
