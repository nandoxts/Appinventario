import Foundation

final class AppDependencies {
    static let shared = AppDependencies()
    private init() {}

    private let productRepository: ProductRepositoryProtocol = DataManager.shared
    private let transactionRepository: TransactionRepositoryProtocol = DataManager.shared
    private let userRepository: UserRepositoryProtocol = UserManager.shared

    lazy var productUseCases = ProductUseCases(repository: productRepository)
    lazy var transactionUseCases = TransactionUseCases(productRepository: productRepository, transactionRepository: transactionRepository)
    lazy var authUseCases = AuthUseCases(repository: userRepository)
    lazy var userManagementUseCases = UserManagementUseCases(repository: userRepository)
    lazy var reportUseCases = ReportUseCases(productRepository: productRepository, transactionRepository: transactionRepository)
}
