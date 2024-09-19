//
//  FavouritesCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 10.09.2024.
//

import UIKit
import FirebaseAuth

class FavouritesCell: UICollectionViewCell {

    var onDeleteButtonTapped: (() -> Void)?
    var onAddToBasketButtonTapped: (() -> Void)?

    private let favouriteProductImageContainer: UIView = 
    {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.layer.cornerRadius = 6
        imageContainer.layer.masksToBounds = true
        imageContainer.layer.borderWidth = 1
        imageContainer.layer.borderColor = CGColor(gray: 0.3, alpha: 0.2)

        return imageContainer
    }()

    private let productImageView: UIImageView = 
    {
        let productImageView = UIImageView()
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFit

        return productImageView
    }()

    private let productTitleLabel: UILabel = 
    {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black

        return titleLabel
    }()

    private let productStarImageView: UIImageView = 
    {
        let starImageView = UIImageView()
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.contentMode = .scaleAspectFill

        return starImageView
    }()

    private let productShipmentTypeLabel: UILabel = 
    {
        let shipmentLabel = UILabel()
        shipmentLabel.translatesAutoresizingMaskIntoConstraints = false
        shipmentLabel.font = .systemFont(ofSize: 11, weight: .regular)
        shipmentLabel.numberOfLines = 0
        shipmentLabel.textColor = .gray

        return shipmentLabel
    }()

    private let productFormattedPriceLabel: UILabel = 
    {
        let formattedPriceLabel = UILabel()
        formattedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        formattedPriceLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        formattedPriceLabel.numberOfLines = 0
        formattedPriceLabel.textColor = .black

        return formattedPriceLabel
    }()

    let productDeletionButton: UIButton = 
    {
        let deletionButton = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemGray.withAlphaComponent(0.6))
        let image = UIImage(systemName: "trash")?.applyingSymbolConfiguration(symbolConfig)
        deletionButton.translatesAutoresizingMaskIntoConstraints = false
        deletionButton.setImage(image, for: .normal)

        return deletionButton
    }()

    let productAddToBasketButton: UIButton = 
    {
        let addToBasketButton = UIButton()
        let colorConfiguration = UIImage.SymbolConfiguration(hierarchicalColor: .purple11)
        let sizeConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        let combinedConfiguration = colorConfiguration.applying(sizeConfiguration)

        let image = UIImage(systemName: "plus")?.applyingSymbolConfiguration(combinedConfiguration)
        addToBasketButton.setImage(image, for: .normal)
        addToBasketButton.translatesAutoresizingMaskIntoConstraints = false
        addToBasketButton.layer.borderWidth = 1
        addToBasketButton.layer.borderColor = UIColor.purple11.cgColor
        addToBasketButton.layer.masksToBounds = true
        addToBasketButton.layer.cornerRadius = 6


        return addToBasketButton
    }()

    @objc private func deleteButtonTapped() 
    {
        productDeletionButton.isEnabled = false
        productAddToBasketButton.isEnabled = false
        onDeleteButtonTapped?()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.productDeletionButton.isEnabled = true
            self?.productAddToBasketButton.isEnabled = true
        }
    }

    @objc private func addToBasketButtonTapped() 
    {
        productDeletionButton.isEnabled = false
        productAddToBasketButton.isEnabled = false
        onAddToBasketButtonTapped?()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.productDeletionButton.isEnabled = true
            self?.productAddToBasketButton.isEnabled = true
        }
    }


    override init(frame: CGRect) 
    {
        super.init(frame: frame)
        self.backgroundColor = .white
        productImageSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func productImageSetup()
    {
        productDeletionButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        productAddToBasketButton.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)

        contentView.addSubview(favouriteProductImageContainer)
        favouriteProductImageContainer.addSubview(productImageView)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(productDeletionButton)
        contentView.addSubview(productAddToBasketButton)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(productStarImageView)
        contentView.addSubview(productShipmentTypeLabel)
        contentView.addSubview(productFormattedPriceLabel)

        NSLayoutConstraint.activate([
            favouriteProductImageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            favouriteProductImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            favouriteProductImageContainer.widthAnchor.constraint(equalToConstant: 90),
            favouriteProductImageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            productImageView.topAnchor.constraint(equalTo: favouriteProductImageContainer.topAnchor, constant: 0),
            productImageView.bottomAnchor.constraint(equalTo: favouriteProductImageContainer.bottomAnchor),
            productImageView.centerXAnchor.constraint(equalTo: favouriteProductImageContainer.centerXAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 86),

            productDeletionButton.topAnchor.constraint(equalTo: favouriteProductImageContainer.topAnchor),
            productDeletionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            productDeletionButton.leadingAnchor.constraint(equalTo: productAddToBasketButton.leadingAnchor, constant: 0),
            productDeletionButton.heightAnchor.constraint(equalToConstant: 20),

            productAddToBasketButton.bottomAnchor.constraint(equalTo: favouriteProductImageContainer.bottomAnchor, constant: 0),
            productAddToBasketButton.widthAnchor.constraint(equalToConstant: 32),
            productAddToBasketButton.heightAnchor.constraint(equalToConstant: 32),
            productAddToBasketButton.trailingAnchor.constraint(equalTo: productDeletionButton.trailingAnchor),

            productTitleLabel.topAnchor.constraint(equalTo: favouriteProductImageContainer.topAnchor, constant: 0),
            productTitleLabel.leadingAnchor.constraint(equalTo: favouriteProductImageContainer.trailingAnchor, constant: 12),
            productTitleLabel.trailingAnchor.constraint(equalTo: productAddToBasketButton.leadingAnchor, constant: -10),

            productStarImageView.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 4),
            productStarImageView.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor, constant: -10),
            productStarImageView.widthAnchor.constraint(equalToConstant: 80),
            productStarImageView.heightAnchor.constraint(equalToConstant: 15),

            productShipmentTypeLabel.topAnchor.constraint(equalTo: productStarImageView.bottomAnchor, constant: 5),
            productShipmentTypeLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
            productShipmentTypeLabel.widthAnchor.constraint(equalTo: productStarImageView.widthAnchor),

            productFormattedPriceLabel.bottomAnchor.constraint(equalTo: favouriteProductImageContainer.bottomAnchor, constant: -10),
            productFormattedPriceLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),

        ])
    }


    // Bind fonksiyonu
    func bind(_ model: SavedProductCardPresentationModel) {
        productTitleLabel.text = model.productTitle
        
        if model.productRate 
        {
            productStarImageView.isHidden = false
            productStarImageView.image = UIImage(named: "star-100")
        }
        else
        {
            productStarImageView.isHidden = true
        }

        if model.freeShipment 
        {
            productShipmentTypeLabel.isHidden = false
            productShipmentTypeLabel.text = "Ücretsiz Kargo"
        }
        else
        {
            productShipmentTypeLabel.isHidden = true
        }

        let price = formattedPrice(from: model.productPrice)
        productFormattedPriceLabel.text = price

        downloadImage(with: model.productImages[0]) 
        {
            image in
            self.productImageView.image = image
        }
    }
}

