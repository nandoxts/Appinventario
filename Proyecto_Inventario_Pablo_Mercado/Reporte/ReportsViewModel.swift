import Foundation

final class ReportsViewModel {
    private let reportUseCases: ReportUseCases

    init(reportUseCases: ReportUseCases = AppDependencies.shared.reportUseCases) {
        self.reportUseCases = reportUseCases
    }

    private var summary: ReportSummary { reportUseCases.summary() }

    var totalProducts: Int { summary.totalProducts }
    var totalStock: Int { summary.totalStock }
    var lowStockProducts: [Product] { summary.lowStockProducts }
    var totalEntries: Int { summary.totalEntries }
    var totalExits: Int { summary.totalExits }
}
