//
//  ConceptBottomSliderCollectionViewCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 11.08.2024.
//

import UIKit

class HomeModuleConceptBottomBrandCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HomeModuleConceptBottomBrandCell"
    
    private let conceptBrandContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let brandImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        contentView.addSubview(conceptBrandContainer)
        conceptBrandContainer.addSubview(brandImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            conceptBrandContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conceptBrandContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            conceptBrandContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            conceptBrandContainer.heightAnchor.constraint(equalTo: conceptBrandContainer.widthAnchor),
            
            brandImage.centerXAnchor.constraint(equalTo: conceptBrandContainer.centerXAnchor),
            brandImage.centerYAnchor.constraint(equalTo: conceptBrandContainer.centerYAnchor),
            brandImage.widthAnchor.constraint(equalTo: conceptBrandContainer.widthAnchor),
            brandImage.heightAnchor.constraint(equalTo: brandImage.widthAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBrandContainerAppearance()
    }
    
    private func setupBrandContainerAppearance() {
        conceptBrandContainer.layer.cornerRadius = conceptBrandContainer.frame.size.width / 2
        conceptBrandContainer.layer.masksToBounds = true
        
        brandImage.layer.cornerRadius = brandImage.frame.size.width / 2
        brandImage.layer.masksToBounds = true
    }
    
    func setupBrandContainer(with model: HomeModuleConceptBottomBrandPresentationModel) {
        downloadImage(with: model.brandImage) { image in
                self.brandImage.image = image   
        }

    }
}

