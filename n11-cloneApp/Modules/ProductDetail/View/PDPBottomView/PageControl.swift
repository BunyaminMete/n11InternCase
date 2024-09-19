//
//  ProductDetailFooterView.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 10.08.2024.
//

import UIKit

class ProductDetailFooterView: UICollectionReusableView {
    static let reuseIdentifier = "ProductDetailFooterView"

    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.backgroundColor = .lightGray.withAlphaComponent(0.2)
        pc.layer.cornerRadius = 10
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .black
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pageControl)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(pageControl)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
