//
//  ProductDetailImageCollectionViewCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 8.08.2024.
//

import UIKit

class ProductDetailImageCollectionViewCell: UICollectionViewCell {

    let productDetailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(productDetailImageView)

        NSLayoutConstraint.activate([
            productDetailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productDetailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productDetailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productDetailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configureImageCell(with imageName: String) {
        downloadImage(with: imageName) { image in
            DispatchQueue.main.async {
                self.productDetailImageView.image = image
            }
        }
    }
}
