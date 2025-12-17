import Foundation

final class DataManager {

    static let shared = DataManager()
    private init() {}

    private(set) var products: [Product] = []
    private(set) var transactions: [Transaction] = []

    private let queue = DispatchQueue(label: "DataManagerQueue", attributes: .concurrent)

    // MARK: - Products
    @discardableResult
    func addProduct(_ product: Product) -> Bool {
        queue.async(flags: .barrier) {
            self.products.append(product)
        }
        return true
    }

    @discardableResult
    func updateProduct(_ product: Product) -> Bool {
        var updated = false
        queue.async(flags: .barrier) {
            if let index = self.products.firstIndex(where: { $0.id == product.id }) {
                self.products[index] = product
                updated = true
            }
        }
        return updated
    }

    @discardableResult
    func deleteProduct(id: UUID) -> Bool {
        var deleted = false
        queue.async(flags: .barrier) {
            let originalCount = self.products.count
            self.products.removeAll { $0.id == id }
            deleted = self.products.count < originalCount
        }
        return deleted
    }

    func getProduct(by id: UUID) -> Product? {
        queue.sync {
            products.first { $0.id == id }
        }
    }

    // MARK: - Transactions
    @discardableResult
    func addTransaction(_ transaction: Transaction) -> Bool {
        var success = false
        queue.sync(flags: .barrier) {
            guard let index = products.firstIndex(where: { $0.id == transaction.productId }) else {
                success = false
                return
            }

            var product = products[index]

            switch transaction.type {
            case .entrada:
                product.stock += transaction.quantity
            case .salida:
                guard product.stock >= transaction.quantity else {
                    success = false
                    return
                }
                product.stock -= transaction.quantity
            }

            products[index] = product
            transactions.append(transaction)
            success = true
        }
        return success
    }

    @discardableResult
    func deleteTransaction(id: UUID) -> Bool {
        var success = false
        queue.sync(flags: .barrier) {
            guard let transactionIndex = transactions.firstIndex(where: { $0.id == id }) else {
                success = false
                return
            }

            let transaction = transactions[transactionIndex]

            if let productIndex = products.firstIndex(where: { $0.id == transaction.productId }) {
                var product = products[productIndex]
                switch transaction.type {
                case .entrada:
                    product.stock = max(product.stock - transaction.quantity, 0)
                case .salida:
                    product.stock += transaction.quantity
                }
                products[productIndex] = product
            }

            transactions.remove(at: transactionIndex)
            success = true
        }
        return success
    }
}
