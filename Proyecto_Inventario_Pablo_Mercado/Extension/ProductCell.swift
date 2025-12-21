import UIKit

class ProductCell: UITableViewCell {

    private let cardView = UIView()
    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    private let stockLabel = UILabel()
    private let priceLabel = UILabel()
    private let lowStockBadge = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cardView)

        // Ícono
        iconView.image = UIImage(systemName: "cube.box.fill")
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(iconView)

        // Badge de stock bajo
        lowStockBadge.text = "Stock bajo"
        lowStockBadge.font = .boldSystemFont(ofSize: 10)
        lowStockBadge.textColor = .white
        lowStockBadge.backgroundColor = .systemRed
        lowStockBadge.textAlignment = .center
        lowStockBadge.layer.cornerRadius = 8
        lowStockBadge.clipsToBounds = true
        lowStockBadge.isHidden = true
        lowStockBadge.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(lowStockBadge)

        let stack = UIStackView(arrangedSubviews: [nameLabel, stockLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            lowStockBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            lowStockBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            lowStockBadge.widthAnchor.constraint(equalToConstant: 75),
            lowStockBadge.heightAnchor.constraint(equalToConstant: 20)
        ])

        nameLabel.font = .boldSystemFont(ofSize: 17)
        nameLabel.textColor = .label
        
        stockLabel.font = .systemFont(ofSize: 14)
        stockLabel.textColor = .secondaryLabel
        
        priceLabel.font = .boldSystemFont(ofSize: 15)
        priceLabel.textColor = .systemGreen
    }

    func configure(product: Product) {
        nameLabel.text = product.name
        
        // Cambiar color según stock
        if product.stock <= 5 {
            stockLabel.text = "⚠️ Stock: \(product.stock)"
            stockLabel.textColor = .systemRed
            lowStockBadge.isHidden = false
        } else {
            stockLabel.text = "📦 Stock: \(product.stock)"
            stockLabel.textColor = .secondaryLabel
            lowStockBadge.isHidden = true
        }
        
        priceLabel.text = "💰 $\(product.price)"
    }
}
