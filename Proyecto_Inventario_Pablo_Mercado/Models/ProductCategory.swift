import Foundation

enum ProductCategory: String, CaseIterable, Codable {
    case electronics = "Electrónica"
    case clothing = "Ropa"
    case food = "Alimentos"
    case furniture = "Muebles"
    case other = "Otro"
}
