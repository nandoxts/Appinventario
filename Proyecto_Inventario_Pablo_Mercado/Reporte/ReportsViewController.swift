import UIKit

class ReportsViewController: UIViewController {

    private let viewModel = ReportsViewModel()
    private var lowStockTable: LowStockTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reportes"
        view.backgroundColor = .systemGroupedBackground
        setupUI()
    }

    private func setupUI() {
        let totalProductsCard = ReportCardView(
            title: "Productos",
            icon: "cube.box.fill",
            color: .systemBlue
        )
        totalProductsCard.setValue("\(viewModel.totalProducts)")

        let stockCard = ReportCardView(
            title: "Stock total",
            icon: "archivebox.fill",
            color: .systemGreen
        )
        stockCard.setValue("\(viewModel.totalStock)")

        let entryCard = ReportCardView(
            title: "Entradas",
            icon: "arrow.down.circle.fill",
            color: .systemGreen
        )
        entryCard.setValue("\(viewModel.totalEntries)")

        let exitCard = ReportCardView(
            title: "Salidas",
            icon: "arrow.up.circle.fill",
            color: .systemOrange
        )
        exitCard.setValue("\(viewModel.totalExits)")

        let stack = UIStackView(arrangedSubviews: [
            totalProductsCard, stockCard, entryCard, exitCard
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        if !viewModel.lowStockProducts.isEmpty {
            lowStockTable = LowStockTableView(products: viewModel.lowStockProducts)
            view.addSubview(lowStockTable!)

            NSLayoutConstraint.activate([
                lowStockTable!.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
                lowStockTable!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                lowStockTable!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                lowStockTable!.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.lowStockProducts.count * 44))
            ])
        }
    }
}
