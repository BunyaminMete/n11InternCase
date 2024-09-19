//
//  FakeNavigationComponent.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 12.09.2024.
//

import UIKit

func createFakeNavigationComponent(color: UIColor, height: CGFloat, view: UIView!){
    let fakeView = UIView()
    fakeView.translatesAutoresizingMaskIntoConstraints = false
    fakeView.backgroundColor = color
    view.addSubview(fakeView)

    if let superview = view.superview {
        NSLayoutConstraint.activate([
            fakeView.topAnchor.constraint(equalTo: superview.topAnchor),
            fakeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fakeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fakeView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
