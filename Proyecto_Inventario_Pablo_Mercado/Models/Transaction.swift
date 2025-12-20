import Foundation

enum TransactionType: String, Codable {
    case entrada
    case salida
}

struct Transaction: Codable {
    let id: String
    let productId: Int
    let productName: String
    let quantity: Int
    let type: TransactionType
    let date: Date
}
