import Foundation

final class TransactionUseCases {
    private let productRepository: ProductRepositoryProtocol
    private let transactionRepository: TransactionRepositoryProtocol

    init(productRepository: ProductRepositoryProtocol, transactionRepository: TransactionRepositoryProtocol) {
        self.productRepository = productRepository
        self.transactionRepository = transactionRepository
    }

    var products: [Product] { productRepository.products }
    var transactions: [Transaction] { transactionRepository.transactions }

    func delete(id: String) -> Bool {
        transactionRepository.delete(id: id)
    }

    func create(productIndex: Int, quantity: Int, type: TransactionType) -> Result<(transaction: Transaction, product: Product), TransactionError> {
        let products = productRepository.products
        guard products.indices.contains(productIndex) else { return .failure(.noProducts) }
        guard quantity > 0 else { return .failure(.invalidQuantity) }

        let product = products[productIndex]
        let transaction = Transaction(
            id: UUID().uuidString,
            productId: product.id,
            productName: product.name,
            quantity: quantity,
            type: type,
            date: Date()
        )
        guard transactionRepository.add(transaction) else { return .failure(.insufficientStock) }
        return .success((transaction: transaction, product: product))
    }
}
