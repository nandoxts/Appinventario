import Foundation

final class TransactionViewModel {
    private let transactionUseCases: TransactionUseCases
    private let authUseCases: AuthUseCases

    var products: [Product] { transactionUseCases.products }
    var transactions: [Transaction] { transactionUseCases.transactions }

    init(
        transactionUseCases: TransactionUseCases = AppDependencies.shared.transactionUseCases,
        authUseCases: AuthUseCases = AppDependencies.shared.authUseCases
    ) {
        self.transactionUseCases = transactionUseCases
        self.authUseCases = authUseCases
    }

    func deleteTransaction(_ transaction: Transaction, completion: @escaping (Bool) -> Void) {
        let success = transactionUseCases.delete(id: transaction.id)
        DispatchQueue.main.async { completion(success) }
    }

    func createTransaction(productIndex: Int, quantity: Int, type: TransactionType) -> Result<Void, TransactionError> {
        let result = transactionUseCases.create(productIndex: productIndex, quantity: quantity, type: type)
        switch result {
        case .success(let payload):
            if let adminEmail = authUseCases.currentUser()?.email {
                TransactionEmailService.shared.processTransaction(payload.transaction, product: payload.product, adminEmail: adminEmail)
            }
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
