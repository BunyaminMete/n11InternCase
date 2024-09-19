//
//  CategoryCollectionViewCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 5.08.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryImageView.layer.cornerRadius = 20
        
        categoryLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
    }
    
    func setupCategoryLabel(categoryText: String, categoryImageURL: String){

        categoryLabel.text = categoryText
        categoryLabel.textColor = .darkGray

        downloadImage(with: categoryImageURL) { [weak self] image in
            self?.categoryImageView.image = image
        }
    }

}
