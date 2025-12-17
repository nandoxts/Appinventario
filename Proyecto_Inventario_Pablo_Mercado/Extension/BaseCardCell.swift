import UIKit

class BaseCardCell: UITableViewCell {

    let cardView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCard()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupCard() {
        selectionStyle = .none
        backgroundColor = .clear

        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowRadius = 6
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    // 🔑 ESTO ES LO QUE FALTABA
    override func layoutSubviews() {
        super.layoutSubviews()

        // Evita NaN en CoreGraphics
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }
}
