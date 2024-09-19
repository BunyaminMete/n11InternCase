//
//  BasketProductContainerCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 25.08.2024.
//

protocol BasketProductContainerCellDelegate: AnyObject {
    func didUpdateQuantity(for documentId: String)
}

import UIKit
import FirebaseAuth

class BasketProductContainerCell: UICollectionViewCell {
    weak var delegate: BasketProductContainerCellDelegate?

    static let reuseIdentifier = "BasketProductContainerCell"
    private var documentId: String?

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        activityIndicator.backgroundColor = .purple11

        return activityIndicator
    }()

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let brandLabel: UILabel = {
        let brandLabel = UILabel()
        brandLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        brandLabel.textColor = .black.withAlphaComponent(0.9)
        brandLabel.text = "Nike"
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        return brandLabel
    }()

    private let brandRateLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "10.0"
        label.backgroundColor = UIColor(hex: "#085E1D")
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let productImageContainerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(named: "purple11")
        label.text = "₺1.404,04"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let quantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let decrementButton: UIButton = {
        let button = UIButton()
        let minusImage = UIImage(systemName: "minus")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))


        button.setImage(minusImage, for: .normal)
        button.tintColor = UIColor(named: "purple11") // Butonun simge rengi
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false

        return button
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(named: "purple11")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let incrementButton: UIButton = {
        let button = UIButton()
        let plusImage = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        button.setImage(plusImage, for: .normal)
        button.tintColor = UIColor(named: "purple11")
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false

        return button
    }()

    private let cargoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cargoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cargo_purple")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let cargoCompanyName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "MNG Kargo:"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let cargoShipmentDetail: UILabel = {
        let label = UILabel()
        label.textColor = .darkgreen
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "Ücretsiz Kargo"
        label.translatesAutoresizingMaskIntoConstraints = false


        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)

        contentView.addSubview(headerView)
        headerView.addSubview(brandLabel)
        headerView.addSubview(brandRateLabel)
        contentView.addSubview(containerView)
        containerView.addSubview(productImageContainerView)
        productImageContainerView.addSubview(productImageView)
        containerView.addSubview(productNameLabel)
        containerView.addSubview(productPriceLabel)
        containerView.addSubview(quantityStackView)
        quantityStackView.addArrangedSubview(decrementButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(activityIndicator)
        quantityStackView.addArrangedSubview(incrementButton)

        contentView.addSubview(cargoView)
        cargoView.addSubview(cargoImageView)
        cargoView.addSubview(cargoCompanyName)
        cargoView.addSubview(cargoShipmentDetail)

        NSLayoutConstraint.activate([
            // headerView constraints
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 40),

            brandLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            brandLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),

            brandRateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            brandRateLabel.leadingAnchor.constraint(equalTo: brandLabel.trailingAnchor, constant: 10),

            // containerView constraints
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0.5),
            containerView.heightAnchor.constraint(equalToConstant: 100),

            cargoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            cargoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            cargoView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.5),
            cargoView.heightAnchor.constraint(equalToConstant: 40),

            // cargoImageView constraints
            cargoImageView.leadingAnchor.constraint(equalTo: cargoView.leadingAnchor, constant: 16),
            cargoImageView.centerYAnchor.constraint(equalTo: cargoView.centerYAnchor),
            cargoImageView.widthAnchor.constraint(equalToConstant: 30),
            cargoImageView.heightAnchor.constraint(equalToConstant: 30),

            // cargoCompanyName constraints
            cargoCompanyName.leadingAnchor.constraint(equalTo: cargoImageView.trailingAnchor, constant: 8),
            cargoCompanyName.topAnchor.constraint(equalTo: cargoView.topAnchor, constant: 0),
            cargoCompanyName.bottomAnchor.constraint(equalTo: cargoView.bottomAnchor, constant: 0),

            // cargoShipmentDetail constraints
            cargoShipmentDetail.leadingAnchor.constraint(equalTo: cargoCompanyName.trailingAnchor, constant: 5),
            cargoShipmentDetail.topAnchor.constraint(equalTo: cargoView.topAnchor, constant: 0),
            cargoShipmentDetail.bottomAnchor.constraint(equalTo: cargoView.bottomAnchor, constant: 0),


            // productImageContainerView constraints
            productImageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            productImageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            productImageContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            productImageContainerView.widthAnchor.constraint(equalToConstant: 70),

            // productImageView constraints
            productImageView.leadingAnchor.constraint(equalTo: productImageContainerView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: productImageContainerView.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: productImageContainerView.topAnchor, constant: 10),
            productImageView.bottomAnchor.constraint(equalTo: productImageContainerView.bottomAnchor, constant: -10),

            // productNameLabel constraints
            productNameLabel.leadingAnchor.constraint(equalTo: productImageContainerView.trailingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: quantityStackView.leadingAnchor, constant: -16),
            productNameLabel.topAnchor.constraint(equalTo: productImageContainerView.topAnchor, constant: 10),

            // productPriceLabel constraints
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            productPriceLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),

            // quantityStackView constraints
            quantityStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            quantityStackView.centerYAnchor.constraint(equalTo: productImageContainerView.centerYAnchor),
            quantityStackView.widthAnchor.constraint(equalToConstant: 100),
            quantityStackView.heightAnchor.constraint(equalToConstant: 33),
        ])
    }

    private func quantityButtonTriggered(activity: Bool){
        activityIndicator.startAnimating()
        incrementButton.isEnabled = !activity
        decrementButton.isEnabled = !activity
        activityIndicator.isHidden = !activity
        quantityLabel.isHidden = activity
    }


    @objc private func decrementButtonTapped() {
        quantityButtonTriggered(activity: true)
        if let quantityText = quantityLabel.text, let quantity = Int(quantityText), quantity > 1 {
            let newQuantity = quantity - 1
            quantityLabel.text = newQuantity == 0 ? "\(newQuantity + 1)" : "\(newQuantity)"
            if let productTitle = self.productNameLabel.text {
                let userUID = Auth.auth().currentUser?.uid
                FirestoreNetworking().updateProductAmount(forUserUID: userUID!,
                                                          productTitle: productTitle,
                                                          amount: newQuantity) { error in
                    if let error = error 
                    {
                        print("Error updating product amount: \(error.localizedDescription)")
                        self.quantityButtonTriggered(activity: false)

                    } 
                    else
                    {
                        print("Product amount updated successfully.")
                        self.delegate?.didUpdateQuantity(for: productTitle)
                        self.quantityButtonTriggered(activity: false)
                        self.quantityLabel.text = newQuantity == 0 ? "\(newQuantity + 1)" : "\(newQuantity)"
                    }
                }
            }
        }
        else
        {
            guard let userUID = Auth.auth().currentUser?.uid else {
                return
            }
            FirestoreNetworking().deleteProduct(forUserUID: userUID, documentId: self.documentId!) { error in
                if let error = error
                {
                    print("Error deleting product")
                    print(error.localizedDescription)
                }
                else
                {
                    self.quantityButtonTriggered(activity: false)
                    self.delegate?.didUpdateQuantity(for: self.productNameLabel.text!)
                }
            }
        }
    }


    @objc private func incrementButtonTapped() {
        quantityButtonTriggered(activity: true)
        if let quantityText = quantityLabel.text, let quantity = Int(quantityText) {
            if let productTitle = self.productNameLabel.text {
                let userUID = Auth.auth().currentUser?.uid
                FirestoreNetworking().updateProductAmount(forUserUID: userUID!,
                                                          productTitle: productTitle,
                                                          amount: quantity + 1) { error in
                    if let error = error {
                        print("Error updating product amount: \(error.localizedDescription)")
                        self.quantityButtonTriggered(activity: false)
                    } else {
                        print("Product amount updated successfully.")
                        self.delegate?.didUpdateQuantity(for: productTitle)
                        self.quantityLabel.text = "\(quantity + 1)"
                        self.quantityButtonTriggered(activity: false)
                    }
                }
            }
        }
    }

    func configure(with productName: String,
                   image: UIImage?,
                   productPrice: Double,
                   amount: Int, documentId: String)
    {
        let setPriceFormat = formattedPriceForCell(from: productPrice)
        productNameLabel.text = productName
        productPriceLabel.text = "\(setPriceFormat)"
        productImageView.image = image
        quantityLabel.text = "\(amount)"
        self.documentId = documentId

        let minusImage = UIImage(systemName: "minus")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))

        let garbageImage = UIImage(systemName: "trash")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))

        if amount > 1 {
            decrementButton.setImage(minusImage, for: .normal)
        } else {
            decrementButton.setImage(garbageImage, for: .normal)
        }
    }
}




