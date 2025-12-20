import Foundation

final class DataManager {

    static let shared = DataManager()
    private init() {
        loadProducts()
        loadTransactions()
    }

    private(set) var products: [Product] = []
    private(set) var transactions: [Transaction] = []
    private var nextProductId: Int = 1

    private let queue = DispatchQueue(label: "DataManagerQueue", attributes: .concurrent)
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private let productsKey = "productsStore"
    private let transactionsKey = "transactionsStore"
    private let nextIdKey = "nextProductId"
    
    // MARK: - Persistencia
    private func loadProducts() {
        if let data = defaults.data(forKey: productsKey),
           let decoded = try? JSONDecoder().decode([Product].self, from: data) {
            products = decoded
        }
        nextProductId = defaults.integer(forKey: nextIdKey)
        if nextProductId == 0 { nextProductId = 1 }
    }
    
    private func saveProducts() {
        if let data = try? JSONEncoder().encode(products) {
            defaults.set(data, forKey: productsKey)
        }
        defaults.set(nextProductId, forKey: nextIdKey)
    }
    
    private func loadTransactions() {
        if let data = defaults.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
    
    private func saveTransactions() {
        if let data = try? JSONEncoder().encode(transactions) {
            defaults.set(data, forKey: transactionsKey)
        }
    }

    // MARK: - Products
    @discardableResult
    func addProduct(_ product: Product) -> Bool {
        queue.async(flags: .barrier) {
            var newProduct = product
            newProduct = Product(id: self.nextProductId, name: product.name, price: product.price, stock: product.stock, category: product.category)
            self.nextProductId += 1
            self.products.append(newProduct)
            self.saveProducts()
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
                self.saveProducts()
            }
        }
        return updated
    }

    func deleteProduct(id: Int, completion: @escaping (Bool) -> Void) {
        queue.async(flags: .barrier) {
            let originalCount = self.products.count
            self.products.removeAll { $0.id == id }
            let deleted = self.products.count < originalCount
            self.saveProducts()

            DispatchQueue.main.async {
                completion(deleted)
            }
        }
    }


    func getProduct(by id: Int) -> Product? {
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
            saveProducts()
            saveTransactions()
            success = true
        }
        return success
    }

    @discardableResult
    func deleteTransaction(id: String) -> Bool {
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
            saveProducts()
            saveTransactions()
            success = true
        }
        return success
    }
}
