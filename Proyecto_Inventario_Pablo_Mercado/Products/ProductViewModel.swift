import Foundation

final class ProductViewModel {
    private let useCases: ProductUseCases

    var products: [Product] { useCases.products }

    init(useCases: ProductUseCases = AppDependencies.shared.productUseCases) {
        self.useCases = useCases
    }

    func addProduct(name: String, priceText: String, stockText: String, category: ProductCategory) -> Result<Void, ProductError> {
        useCases.add(name: name, priceText: priceText, stockText: stockText, category: category)
    }

    func updateProduct(_ product: Product) {
        useCases.update(product)
    }

    func deleteProduct(id: Int, completion: @escaping (Bool) -> Void) {
        useCases.delete(id: id, completion: completion)
    }
}
