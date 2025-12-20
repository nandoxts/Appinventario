import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let price: Double
    var stock: Int
    var category: ProductCategory
}

