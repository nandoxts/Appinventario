import UIKit

class ReportCardView: UIView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let iconView = UIImageView()

    init(title: String, icon: String, color: UIColor) {
        super.init(frame: .zero)
        setupUI(title: title, icon: icon, color: color)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI(title: String, icon: String, color: UIColor) {
        backgroundColor = color.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false

        // Icon
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // Labels
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = color

        valueLabel.text = "0"
        valueLabel.font = .systemFont(ofSize: 22, weight: .bold)
        valueLabel.textColor = color

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconView)
        addSubview(stack)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30),

            stack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func setValue(_ value: String) {
        valueLabel.text = value
    }
}
