//
//  LabelWithNewBadgeAndArrow.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.09.2024.
//

import UIKit

struct UIComponentsFactory {
    static func createLabel(text: String, fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = textColor
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        label.numberOfLines = 2
        return label
    }

    static func createPaddedBadge(text: String, fontSize: CGFloat, textColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat = 8) -> PaddedLabel {
        let paddedLabel = PaddedLabel()
        paddedLabel.translatesAutoresizingMaskIntoConstraints = false
        paddedLabel.text = text
        paddedLabel.font = .systemFont(ofSize: fontSize, weight: .black)
        paddedLabel.textColor = textColor
        paddedLabel.backgroundColor = backgroundColor
        paddedLabel.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        paddedLabel.layer.masksToBounds = true
        paddedLabel.layer.cornerRadius = cornerRadius
        return paddedLabel
    }

    static func createArrowButton() -> UIButton {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        let arrowImage = UIImage(systemName: "arrow.right", withConfiguration: imageConfig)?
            .withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
