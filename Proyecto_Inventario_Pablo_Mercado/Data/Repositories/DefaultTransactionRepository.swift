import Foundation

extension DataManager: TransactionRepositoryProtocol {
    func add(_ transaction: Transaction) -> Bool {
        addTransaction(transaction)
    }

    func delete(id: String) -> Bool {
        deleteTransaction(id: id)
    }
}
