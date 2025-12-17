import Foundation

enum TransactionType {
    case entrada
    case salida
}

struct Transaction {
    let id: UUID
    let productId: UUID
    let productName: String
    let quantity: Int
    let type: TransactionType
    let date: Date
}
