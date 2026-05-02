import Foundation

extension DataManager: ProductRepositoryProtocol {
    func add(_ product: Product) -> Bool {
        addProduct(product)
    }

    func update(_ product: Product) -> Bool {
        updateProduct(product)
    }

    func delete(id: Int, completion: @escaping (Bool) -> Void) {
        deleteProduct(id: id, completion: completion)
    }

    func find(by id: Int) -> Product? {
        getProduct(by: id)
    }
}
