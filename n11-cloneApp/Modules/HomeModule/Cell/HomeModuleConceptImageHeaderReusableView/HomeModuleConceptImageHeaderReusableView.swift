//
//  ConceptTopImageCollectionReusableView.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 11.08.2024.
//

import UIKit

class HomeModuleConceptImageHeaderReusableView: UICollectionReusableView {
    static let headerIdentifier = "HomeModuleConceptImageHeaderReusableView"

    private let conceptImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // ImageView'i ekle
        conceptImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(conceptImageView)

        // ImageView'un tüm kenarları 0 olacak şekilde constraints ayarla
        NSLayoutConstraint.activate([
            conceptImageView.topAnchor.constraint(equalTo: topAnchor),
            conceptImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            conceptImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            conceptImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // ImageView'un içeriğini kesip göstermesi için içerik modunu ayarla
        conceptImageView.contentMode = .scaleToFill
        conceptImageView.clipsToBounds = true
    }

    func configure(with image: UIImage?) {
        conceptImageView.image = image
    }
}

