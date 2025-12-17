import UIKit

final class ReportsViewModel {

    private let products = DataManager.shared.products
    private let transactions = DataManager.shared.transactions

    var totalProducts: Int {
        products.count
    }

    var totalStock: Int {
        products.reduce(0) { $0 + $1.stock }
    }

    var lowStockProducts: [Product] {
        products.filter { $0.stock < 5 }
    }

    var totalEntries: Int {
        transactions
            .filter { $0.type == .entrada }
            .reduce(0) { $0 + $1.quantity }
    }

    var totalExits: Int {
        transactions
            .filter { $0.type == .salida }
            .reduce(0) { $0 + $1.quantity }
    }
}
