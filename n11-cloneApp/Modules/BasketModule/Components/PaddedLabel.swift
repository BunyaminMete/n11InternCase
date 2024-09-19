//
//  CustomStepper.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 26.08.2024.
//

import UIKit

class PaddedLabel: UILabel {
    var textInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawText(in rect: CGRect) {
        let insetsRect = rect.inset(by: textInsets)
        super.drawText(in: insetsRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}


