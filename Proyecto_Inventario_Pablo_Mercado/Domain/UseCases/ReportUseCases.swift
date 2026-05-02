import Foundation

struct ReportSummary {
    let totalProducts: Int
    let totalStock: Int
    let lowStockProducts: [Product]
    let totalEntries: Int
    let totalExits: Int
}

final class ReportUseCases {
    private let productRepository: ProductRepositoryProtocol
    private let transactionRepository: TransactionRepositoryProtocol

    init(productRepository: ProductRepositoryProtocol, transactionRepository: TransactionRepositoryProtocol) {
        self.productRepository = productRepository
        self.transactionRepository = transactionRepository
    }

    func summary() -> ReportSummary {
        let products = productRepository.products
        let transactions = transactionRepository.transactions
        return ReportSummary(
            totalProducts: products.count,
            totalStock: products.reduce(0) { $0 + $1.stock },
            lowStockProducts: products.filter { $0.stock < 5 },
            totalEntries: transactions.filter { $0.type == .entrada }.reduce(0) { $0 + $1.quantity },
            totalExits: transactions.filter { $0.type == .salida }.reduce(0) { $0 + $1.quantity }
        )
    }
}
