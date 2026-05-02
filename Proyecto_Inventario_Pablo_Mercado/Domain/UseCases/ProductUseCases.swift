import Foundation

final class ProductUseCases {
    private let repository: ProductRepositoryProtocol

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }

    var products: [Product] { repository.products }

    func add(name: String, priceText: String, stockText: String, category: ProductCategory) -> Result<Void, ProductError> {
        guard !name.isEmpty else { return .failure(.invalidName) }
        guard let price = Double(priceText), price >= 0 else { return .failure(.invalidPrice) }
        guard let stock = Int(stockText), stock >= 0 else { return .failure(.invalidStock) }
        repository.add(Product(id: 0, name: name, price: price, stock: stock, category: category))
        return .success(())
    }

    func update(_ product: Product) {
        repository.update(product)
    }

    func delete(id: Int, completion: @escaping (Bool) -> Void) {
        repository.delete(id: id, completion: completion)
    }
}
