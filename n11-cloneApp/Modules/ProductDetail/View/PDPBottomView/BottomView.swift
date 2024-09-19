import UIKit

class BottomView: UIView {

    let bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let basketButton: UIButton = {
        let button = UIButton(type: .system)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let plusImage = UIImage(systemName: "plus", withConfiguration: imageConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(plusImage, for: .normal)
        
        // Başlık ayarı için attributedTitle kullanımı
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold) // Font boyutu ve kalınlığı
        ]
        let attributedTitle = NSAttributedString(string: "  Sepete Ekle", attributes: titleAttributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tintColor = .white
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "purple11")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        button.configuration = configuration
        
        return button
    }()
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(topLineView)
        addSubview(bottomLabel)
        addSubview(basketButton)
        
        NSLayoutConstraint.activate([
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 1),
            
            bottomLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: 50),
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            basketButton.centerYAnchor.constraint(equalTo: bottomLabel.centerYAnchor),
            basketButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
