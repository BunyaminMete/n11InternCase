//
//  ProductDetailMiniFeaturesCollectionViewCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 8.08.2024.
//
    
import UIKit

class ProductDetailMiniFeaturesCollectionViewCell: UICollectionViewCell {
    
    
    private let detailMiniContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Üst Label"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let starRateImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let starRateAverageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        
        // SFSymbol image ve ayarları
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        let favouriteImage = UIImage(systemName: "heart", withConfiguration: imageConfig)?.withTintColor(UIColor(named: "purple11")!, renderingMode: .alwaysOriginal)
        button.setImage(favouriteImage, for: .normal)
        
        // Başlık ayarı
        button.setTitle(" 0", for: .normal)
        button.setTitleColor(UIColor(named: "purple11"), for: .normal)
        
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let separator1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomBox1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomBox2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomBox3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separator2: UIView = {
        let view = UIView() 
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    private func createBottomBox(title: String, labelText: String) -> UIView {
        let box = UIView()
        box.translatesAutoresizingMaskIntoConstraints = false
        box.backgroundColor = .white
        box.layoutMargins = UIEdgeInsets(top: 1, left: 10, bottom: 10, right: 10)
        box.layer.cornerRadius = 5
        
        box.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        box.layer.borderWidth = 1
        
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 10)
        titleLabel.textColor = .gray.withAlphaComponent(0.8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let detailLabel = UILabel()
        detailLabel.text = labelText
        detailLabel.font = UIFont.systemFont(ofSize: 10)
        detailLabel.textColor = .black.withAlphaComponent(0.95)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        box.addSubview(titleLabel)
        box.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: box.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: box.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: box.layoutMarginsGuide.trailingAnchor),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: box.layoutMarginsGuide.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: box.layoutMarginsGuide.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: box.layoutMarginsGuide.bottomAnchor),
        ])
        return box
    }
    
    private let finalLabel1: UILabel = {
        let label = UILabel()
        label.text = "N11"
        label.textColor = UIColor(named: "purple11")
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let finalLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "9.5"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let finalLabel2Container: UIView = {
        let containerView = UIView()
        containerView.backgroundColor =  UIColor(named: "darkgreen")
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        return containerView
    }()
    
    private let finalLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "purple11")
        let attributedString = NSMutableAttributedString.init(string: "Soru-Cevap")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                        NSRange.init(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupViews()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupViews()
        }
    }
    
    func configureMiniFeaturesCell(with featureText: String, withStar: Bool) {
        topLabel.text = featureText

        if withStar {
            starRateImageView.isHidden = false
            starRateImageView.image = UIImage(named: "star-100")
            starRateAverageLabel.text = "5.0"
        }
    }
    
    private func setupViews() {
        contentView.addSubview(detailMiniContainer) // Burada contentView'a ekliyoruz
        detailMiniContainer.addSubview(topLabel)
        detailMiniContainer.addSubview(starRateImageView)
        detailMiniContainer.addSubview(starRateAverageLabel)
        detailMiniContainer.addSubview(favouriteButton)
        detailMiniContainer.addSubview(separator1)
        detailMiniContainer.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomBox1)
        bottomContainer.addSubview(bottomBox2)
        bottomContainer.addSubview(bottomBox3)
        detailMiniContainer.addSubview(separator2)
        detailMiniContainer.addSubview(finalLabel1)
        finalLabel2Container.addSubview(finalLabel2)
        detailMiniContainer.addSubview(finalLabel2Container)
        detailMiniContainer.addSubview(finalLabel3)
        
        
        let bottomBoxes = [
            createBottomBox(title: "Marka", labelText: "Ofisinin"),
            createBottomBox(title: "Sayfa Tipi", labelText: "Çizgili - Kareli"),
            createBottomBox(title: "Sayfa Sayısı", labelText: "60"),
            createBottomBox(title: "Defter Tipi", labelText: "Spiralli"),

           
        ]
        
        // Add bottom boxes to bottomBox1
        bottomBoxes.forEach { box in
            bottomBox1.addSubview(box)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // detailMiniContainer Constraints
            detailMiniContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailMiniContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailMiniContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            detailMiniContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Top Label Constraints
            topLabel.leadingAnchor.constraint(equalTo: detailMiniContainer.leadingAnchor, constant: 15),
            topLabel.trailingAnchor.constraint(equalTo: detailMiniContainer.trailingAnchor, constant: -10),
            topLabel.topAnchor.constraint(equalTo: detailMiniContainer.topAnchor, constant: 10),
            
            // Sub Label 1 Constraints
            starRateImageView.leadingAnchor.constraint(equalTo: detailMiniContainer.leadingAnchor, constant: 15),
            starRateImageView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 0),
            starRateImageView.widthAnchor.constraint(equalToConstant: 120),
            starRateImageView.heightAnchor.constraint(equalToConstant: 40),
            
            
            // Sub ImageView Constraints
            starRateAverageLabel.leadingAnchor.constraint(equalTo: starRateImageView.trailingAnchor, constant: -2),
            starRateAverageLabel.centerYAnchor.constraint(equalTo: starRateImageView.centerYAnchor),
            
            // Sub Label 2 Constraints
            favouriteButton.leadingAnchor.constraint(equalTo: detailMiniContainer.trailingAnchor, constant: detailMiniContainer.bounds.width - 50),
            favouriteButton.centerYAnchor.constraint(equalTo: starRateImageView.centerYAnchor),
            
            // Separator 1 Constraints
            separator1.leadingAnchor.constraint(equalTo: detailMiniContainer.leadingAnchor, constant: 15),
            separator1.trailingAnchor.constraint(equalTo: detailMiniContainer.trailingAnchor, constant: -15),
            separator1.topAnchor.constraint(equalTo: starRateImageView.bottomAnchor, constant: 10),
            separator1.heightAnchor.constraint(equalToConstant: 1),
            
            // Bottom Container Constraints
            bottomContainer.leadingAnchor.constraint(equalTo: detailMiniContainer.leadingAnchor, constant: 5),
            bottomContainer.trailingAnchor.constraint(equalTo: detailMiniContainer.trailingAnchor),
            bottomContainer.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 10),
            bottomContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // Bottom Box1 Constraints
            bottomBox1.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 20),
            bottomBox1.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 10),
            bottomBox1.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor),
            
            // Adding constraints for boxes inside bottomBox1
            bottomBox1.subviews[0].leadingAnchor.constraint(equalTo: bottomBox1.leadingAnchor),
            bottomBox1.subviews[0].topAnchor.constraint(equalTo: bottomBox1.topAnchor),
            bottomBox1.subviews[0].bottomAnchor.constraint(equalTo: bottomBox1.bottomAnchor),
            
            bottomBox1.subviews[1].leadingAnchor.constraint(equalTo: bottomBox1.subviews[0].trailingAnchor, constant: 25),
            bottomBox1.subviews[1].topAnchor.constraint(equalTo: bottomBox1.topAnchor),
            bottomBox1.subviews[1].bottomAnchor.constraint(equalTo: bottomBox1.bottomAnchor),
            
            bottomBox1.subviews[2].leadingAnchor.constraint(equalTo: bottomBox1.subviews[1].trailingAnchor, constant: 8),
            bottomBox1.subviews[2].topAnchor.constraint(equalTo: bottomBox1.topAnchor),
            bottomBox1.subviews[2].bottomAnchor.constraint(equalTo: bottomBox1.bottomAnchor),
            
            
            // Separator 2 Constraints
            separator2.leadingAnchor.constraint(equalTo: detailMiniContainer.leadingAnchor, constant: 15),
            separator2.trailingAnchor.constraint(equalTo: detailMiniContainer.trailingAnchor,constant: -15),
            separator2.topAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 20),
            separator2.heightAnchor.constraint(equalToConstant: 1),
            
            
            // Final Label Constraints
            finalLabel1.leadingAnchor.constraint(equalTo: detailMiniContainer.leadingAnchor, constant: 20),
            finalLabel1.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 10),
            
            
            finalLabel2Container.leadingAnchor.constraint(equalTo: finalLabel1.trailingAnchor, constant: 3),
            finalLabel2Container.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 5),
            
            finalLabel2.leadingAnchor.constraint(equalTo: finalLabel2Container.leadingAnchor, constant: 5),
            finalLabel2.trailingAnchor.constraint(equalTo: finalLabel2Container.trailingAnchor, constant: -5),
            finalLabel2.topAnchor.constraint(equalTo: finalLabel2Container.topAnchor, constant: 5),
            finalLabel2.bottomAnchor.constraint(equalTo: finalLabel2Container.bottomAnchor, constant: -5),
            
            
            finalLabel3.trailingAnchor.constraint(equalTo: detailMiniContainer.trailingAnchor, constant: -10),
            finalLabel3.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 10),
            
            
        ])
    }
}
