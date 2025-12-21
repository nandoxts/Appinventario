import UIKit

class UserCell: UITableViewCell {

    private let cardView = UIView()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let roleLabel = UILabel()

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

        // Avatar circular con iniciales
        avatarView.layer.cornerRadius = 25
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .systemBlue
        avatarView.contentMode = .center
        avatarView.tintColor = .white
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(avatarView)

        // Nombre
        nameLabel.font = .boldSystemFont(ofSize: 17)
        nameLabel.textColor = .label
        
        // Email
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .secondaryLabel
        
        // Rol badge
        roleLabel.font = .boldSystemFont(ofSize: 11)
        roleLabel.textColor = .white
        roleLabel.textAlignment = .center
        roleLabel.layer.cornerRadius = 6
        roleLabel.clipsToBounds = true
        roleLabel.translatesAutoresizingMaskIntoConstraints = false

        let infoStack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [avatarView, infoStack, roleLabel])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            avatarView.widthAnchor.constraint(equalToConstant: 50),
            avatarView.heightAnchor.constraint(equalToConstant: 50),

            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            roleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            roleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(user: AppUser) {
        nameLabel.text = user.name
        emailLabel.text = user.email

        // Avatar con iniciales
        let initials = user.name.split(separator: " ")
            .prefix(2)
            .map { String($0.first ?? " ") }
            .joined()
            .uppercased()

        let label = UILabel()
        label.text = initials
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let image = renderer.image { ctx in
            UIColor.systemBlue.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            label.drawText(in: CGRect(x: 0, y: 10, width: 50, height: 30))
        }
        avatarView.image = image

        // Rol badge con color
        roleLabel.text = user.role.displayName
        roleLabel.backgroundColor = user.role == .admin ? .systemRed : .systemGreen
    }
}
