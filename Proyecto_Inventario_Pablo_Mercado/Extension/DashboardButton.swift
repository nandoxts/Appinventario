import UIKit

final class DashboardButton: UIControl {

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    init(
        title: String,
        subtitle: String,
        icon: String,
        color: UIColor
    ) {
        super.init(frame: .zero)
        setupUI(title: title, subtitle: subtitle, icon: icon, color: color)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI(
        title: String,
        subtitle: String,
        icon: String,
        color: UIColor
    ) {
        backgroundColor = color
        layer.cornerRadius = 18

        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit

        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white

        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .white.withAlphaComponent(0.85)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let stack = UIStackView(arrangedSubviews: [iconView, textStack])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
