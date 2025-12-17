import UIKit

class TransactionCell: UITableViewCell {

    private let cardView = UIView()
    private let productLabel = UILabel()
    private let typeLabel = UILabel()
    private let quantityLabel = UILabel()
    private let dateLabel = UILabel()

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
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowRadius = 6
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cardView)

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

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])

        productLabel.font = .boldSystemFont(ofSize: 16)
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = .systemGray
        quantityLabel.font = .systemFont(ofSize: 14)
        quantityLabel.textColor = .systemGray
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .systemGray2
    }

    func configure(transaction: Transaction) {
        productLabel.text = transaction.productName
        typeLabel.text = transaction.type == .entrada ? "Entrada" : "Salida"
        quantityLabel.text = "Cantidad: \(transaction.quantity)"

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: transaction.date)
    }
}
