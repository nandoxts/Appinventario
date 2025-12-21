import UIKit

class TransactionCell: UITableViewCell {

    private let cardView = UIView()
    private let iconView = UIImageView()
    private let productLabel = UILabel()
    private let typeLabel = UILabel()
    private let quantityLabel = UILabel()
    private let dateLabel = UILabel()
    private let highQuantityBadge = UILabel()

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

        // Ícono de tipo
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(iconView)

        // Badge de cantidad alta
        highQuantityBadge.text = "Cantidad alta"
        highQuantityBadge.font = .boldSystemFont(ofSize: 10)
        highQuantityBadge.textColor = .white
        highQuantityBadge.backgroundColor = .systemPurple
        highQuantityBadge.textAlignment = .center
        highQuantityBadge.layer.cornerRadius = 8
        highQuantityBadge.clipsToBounds = true
        highQuantityBadge.isHidden = true
        highQuantityBadge.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(highQuantityBadge)

        let stack = UIStackView(arrangedSubviews: [productLabel, typeLabel, quantityLabel, dateLabel])
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

            highQuantityBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            highQuantityBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            highQuantityBadge.widthAnchor.constraint(equalToConstant: 95),
            highQuantityBadge.heightAnchor.constraint(equalToConstant: 20)
        ])

        productLabel.font = .boldSystemFont(ofSize: 17)
        productLabel.textColor = .label
        
        typeLabel.font = .systemFont(ofSize: 14)
        
        quantityLabel.font = .boldSystemFont(ofSize: 15)
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
    }

    func configure(transaction: Transaction) {
        productLabel.text = transaction.productName

        // Configurar color e ícono según tipo
        if transaction.type == .entrada {
            iconView.image = UIImage(systemName: "arrow.down.circle.fill")
            iconView.tintColor = .systemGreen
            typeLabel.text = "⬇️ Entrada"
            typeLabel.textColor = .systemGreen
            quantityLabel.textColor = .systemGreen
        } else {
            iconView.image = UIImage(systemName: "arrow.up.circle.fill")
            iconView.tintColor = .systemOrange
            typeLabel.text = "⬆️ Salida"
            typeLabel.textColor = .systemOrange
            quantityLabel.textColor = .systemOrange
        }
        
        quantityLabel.text = "Cantidad: \(transaction.quantity)"
        
        // Mostrar badge si cantidad >= 50
        highQuantityBadge.isHidden = transaction.quantity < 50

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateLabel.text = "📅 " + formatter.string(from: transaction.date)
    }
}
