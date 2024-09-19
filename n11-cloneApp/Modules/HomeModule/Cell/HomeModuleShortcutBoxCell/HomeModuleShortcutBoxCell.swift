import UIKit

class HomeModuleShortcutBoxCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeModuleShortcutBoxCell"

    private let topCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let topCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 11.5, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let topCategoryContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(topCategoryContainerView)
        topCategoryContainerView.addSubview(topCategoryImageView)
        topCategoryContainerView.addSubview(topCategoryLabel)
        
        // Add constraints to the container view
        topCategoryContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topCategoryContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topCategoryContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            topCategoryContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            topCategoryContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Add constraints to the image view
        topCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topCategoryImageView.leadingAnchor.constraint(equalTo: topCategoryContainerView.leadingAnchor),
            topCategoryImageView.trailingAnchor.constraint(equalTo: topCategoryContainerView.trailingAnchor),
            topCategoryImageView.topAnchor.constraint(equalTo: topCategoryContainerView.topAnchor, constant: -5),
            topCategoryImageView.heightAnchor.constraint(equalTo: topCategoryContainerView.heightAnchor, multiplier: 0.7)
        ])
        
        // Add constraints to the label
        topCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topCategoryLabel.leadingAnchor.constraint(equalTo: topCategoryContainerView.leadingAnchor, constant: -15),
            topCategoryLabel.trailingAnchor.constraint(equalTo: topCategoryContainerView.trailingAnchor, constant: 15),
            topCategoryLabel.bottomAnchor.constraint(equalTo: topCategoryContainerView.bottomAnchor, constant: -5),
            topCategoryLabel.topAnchor.constraint(equalTo: topCategoryImageView.bottomAnchor, constant: 5)
        ])
    }
    
    func setup(model: HomeModuleShortcutBoxPresentationModel) {
        topCategoryLabel.text = model.title

        let imageURL = model.imageName
        downloadImage(with: imageURL) { [weak self] image in
            self?.topCategoryImageView.image = image
        }
        
        if model.title == "Tıklamayan Kalmasın" {
            topCategoryLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        }
    }
}
