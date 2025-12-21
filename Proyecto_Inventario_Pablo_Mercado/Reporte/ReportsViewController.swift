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
        // ScrollView para contenido scrollable
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

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

        contentView.addSubview(stack)

        // Agregar título de stock bajo si hay
        var stackElements: [UIView] = [stack]
        
        if !viewModel.lowStockProducts.isEmpty {
            let lowStockTitle = UILabel()
            lowStockTitle.text = "Productos con Stock Bajo"
            lowStockTitle.font = .boldSystemFont(ofSize: 18)
            lowStockTitle.textColor = .label
            lowStockTitle.translatesAutoresizingMaskIntoConstraints = false

            lowStockTable = LowStockTableView(products: viewModel.lowStockProducts)
            lowStockTable?.translatesAutoresizingMaskIntoConstraints = false

            let lowStockStack = UIStackView(arrangedSubviews: [lowStockTitle, lowStockTable!])
            lowStockStack.axis = .vertical
            lowStockStack.spacing = 12
            lowStockStack.translatesAutoresizingMaskIntoConstraints = false
            
            stackElements.append(lowStockStack)
        }

        let mainStack = UIStackView(arrangedSubviews: stackElements)
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)

        // ScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        if let lowStockTable = lowStockTable {
            lowStockTable.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.lowStockProducts.count * 44)).isActive = true
        }
    }
}
