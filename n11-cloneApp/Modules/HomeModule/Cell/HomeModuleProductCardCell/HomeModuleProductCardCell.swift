//
//  ProductCardCollectionViewCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 2.08.2024.
//

import UIKit

class HomeModuleProductCardCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeModuleProductCardCell"
    
    @IBOutlet weak var productCardContainerView: UIView!
    @IBOutlet weak var productCardImageView: UIImageView!
    @IBOutlet weak var productCardLabel: UILabel!
    @IBOutlet weak var productStarRating: UIImageView!
    @IBOutlet weak var freeShipmentLabel: UILabel!
    @IBOutlet weak var productCardPriceLabel: UILabel!
    @IBOutlet weak var productCardImageContainer: UIView!
    @IBOutlet weak var productCardPriceLabelContainer: UIView!
    @IBOutlet weak var productCardDescriptionContainer: UIView!
    @IBOutlet weak var productCardStarRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        productCardPriceLabel?.textColor = .black
        productCardPriceLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        productCardImageContainer?.backgroundColor = .clear
        productCardDescriptionContainer?.backgroundColor = .clear
        productCardPriceLabelContainer?.backgroundColor = .clear
        
        productCardLabel?.numberOfLines = 2
        productCardLabel?.font = .systemFont(ofSize: 13, weight: .light)
        productCardLabel?.textColor = .black.withAlphaComponent(1)
        
        freeShipmentLabel?.textAlignment = .center
        freeShipmentLabel?.text = "ÜCRETSİZ KARGO"
        freeShipmentLabel?.backgroundColor = UIColor(white: 0.5, alpha: 0.1)
        freeShipmentLabel?.textColor = UIColor(named: "purple11")
        freeShipmentLabel?.font = UIFont.systemFont(ofSize: 10, weight: .black)
        
        productCardContainerView?.layer.cornerRadius = 10
        productCardContainerView?.backgroundColor = .white
        productCardContainerView.isHidden = true
        
        productCardImageView.contentMode = .scaleAspectFit
        

    }
    
    func configureProductCard(with model: HomeModuleProductCardPresentationModel) {
        productCardContainerView.isHidden = false
        if let firstImageURL = model.productImages.first {
            downloadImage(with: firstImageURL) { [weak self] image in
                    self?.productCardImageView?.image = image
            }
        }
        productCardLabel?.text = model.productTitle
        productCardPriceLabel?.text = formattedPrice(from: model.productPrice)

        freeShipmentLabel.isHidden = model.freeShipment ? false : true
        
        if model.productRate {
            productStarRating.isHidden = false
            productCardStarRatingLabel.isHidden = false
            productCardStarRatingLabel.text = "(99)"
            productStarRating.image = UIImage(named: "star-100")
        }
        else {
            productStarRating.isHidden = true
            productCardStarRatingLabel.isHidden = true
        }
    }
    
     
}


