//
//  Label+Padding.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 5.09.2024.
//

import UIKit

class PaddedBadge: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += textInsets.left + textInsets.right
        size.height += textInsets.top + textInsets.bottom
        return size
    }

    override var bounds: CGRect {
        didSet {
            // ensures the label re-renders when the bounds change
            preferredMaxLayoutWidth = bounds.width - (textInsets.left + textInsets.right)
        }
    }
}
