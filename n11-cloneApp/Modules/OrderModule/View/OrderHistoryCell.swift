//
//  OrderHistoryCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 12.09.2024.
//

import UIKit
import FirebaseCore

class OrderHistoryCell: UICollectionViewCell {
    static let reuseIdentifier = "OrderHistoryCell"

    private let imagesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let labelsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let totalOrderPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black

        return label
    }()

    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator.withAlphaComponent(0.1)

        return view
    }()

    private let orderStatusLabel: UILabel = {
        let orderStatusLabel = UILabel()
        orderStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        orderStatusLabel.font = .systemFont(ofSize: 15, weight: .bold)
        orderStatusLabel.textColor = .purple11

        return orderStatusLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(imagesContainerView)
        contentView.addSubview(labelsContainerView)
        contentView.addSubview(divider)
        contentView.addSubview(orderStatusLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imagesContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imagesContainerView.heightAnchor.constraint(equalToConstant: 60),
            imagesContainerView.widthAnchor.constraint(equalToConstant: 90),

            labelsContainerView.leadingAnchor.constraint(equalTo: imagesContainerView.trailingAnchor, constant: 20),
            labelsContainerView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
            labelsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            labelsContainerView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor),

            divider.topAnchor.constraint(equalTo: imagesContainerView.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            divider.heightAnchor.constraint(equalToConstant: 0.5),

            orderStatusLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            orderStatusLabel.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor),
            orderStatusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func bind(_ model: OrdersHistoryPresentationModel) {
        let maxImagesToShow = 2
        let imagesToShow = Array(model.productImages.prefix(maxImagesToShow))
        imagesContainerView.subviews.forEach { $0.removeFromSuperview() }

        for (index, _) in imagesToShow.enumerated() {
            let imageView = createCircularImageView()
            imagesContainerView.addSubview(imageView)

            downloadImage(with: model.productImages[index]) { image in
                imageView.image = image
            }

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor, constant: CGFloat(index * 30)),
                imageView.centerYAnchor.constraint(equalTo: imagesContainerView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 60),
                imageView.heightAnchor.constraint(equalToConstant: 60)
            ])
        }


        let formattedDate = formatOrderDate(from: model.productsOrderDate)
        let orderNumberLabel = createCustomLabel(labelText: "Sipariş No: ", fontSize: Constants.fontSize, fontWeight: .regular)
        let orderNumber = createCustomLabel(labelText: model.productsOrderNumber, fontSize: Constants.fontSize, fontWeight: .bold)
        let orderDateLabel = createCustomLabel(labelText: "Tarih: ", fontSize: Constants.fontSize, fontWeight: .regular)
        let orderDate = createCustomLabel(labelText: formattedDate, fontSize: Constants.fontSize, fontWeight: .bold)
        totalOrderPrice.text = formattedPrice(from: model.productTotalPrice)
        orderStatusLabel.text = model.productsOrderStatus

        labelsContainerView.addSubview(orderNumberLabel)
        labelsContainerView.addSubview(orderNumber)
        labelsContainerView.addSubview(orderDateLabel)
        labelsContainerView.addSubview(orderDate)
        labelsContainerView.addSubview(totalOrderPrice)


        NSLayoutConstraint.activate([
            orderNumberLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            orderNumberLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),

            orderNumber.leadingAnchor.constraint(equalTo: orderNumberLabel.trailingAnchor, constant: 2),
            orderNumber.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),

            orderDateLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            orderDateLabel.topAnchor.constraint(equalTo: orderNumberLabel.bottomAnchor , constant: 4),

            orderDate.leadingAnchor.constraint(equalTo: orderDateLabel.trailingAnchor),
            orderDate.topAnchor.constraint(equalTo: orderNumberLabel.bottomAnchor, constant: 4),

            totalOrderPrice.leadingAnchor.constraint(equalTo: orderDateLabel.leadingAnchor),
            totalOrderPrice.topAnchor.constraint(equalTo: orderDateLabel.bottomAnchor, constant: 4)
        ])
    }

    private func createCircularImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor

        return imageView
    }

    private func createCustomLabel(labelText: String, fontSize: CGFloat, fontWeight: UIFont.Weight) -> UILabel {
        let customLabel = UILabel()
        customLabel.text = labelText
        customLabel.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        customLabel.numberOfLines = 1
        customLabel.textColor = .black

        return customLabel
    }
}

extension OrderHistoryCell {
    enum Constants {
        static let fontSize: CGFloat = 14
    }
}
