//
//  ShortcutViewContainer.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 5.09.2024.
//

import UIKit

func createShortcutViewContainer(withImageName imageName: String) -> UIView {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let shortcutView = UIView()
    shortcutView.backgroundColor = UIColor(named: "orange11")
    shortcutView.translatesAutoresizingMaskIntoConstraints = false
    shortcutView.layer.cornerRadius = 6
    container.addSubview(shortcutView)

    let imageView = UIImageView()
    let icon = UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
    imageView.tintColor = UIColor(named: "purple11")
    imageView.image = icon
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit

    shortcutView.addSubview(imageView)
    shortcutView.isUserInteractionEnabled = true // Tıklanabilir olması için

    NSLayoutConstraint.activate([
        shortcutView.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
        shortcutView.heightAnchor.constraint(equalToConstant: 60),
        shortcutView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
        shortcutView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),

        imageView.centerYAnchor.constraint(equalTo: shortcutView.centerYAnchor),
        imageView.centerXAnchor.constraint(equalTo: shortcutView.centerXAnchor),
        imageView.widthAnchor.constraint(equalToConstant: 36),
        imageView.heightAnchor.constraint(equalToConstant: 36)
    ])

    return container
}

func addLabel(to container: UIView, withText text: String) {
    let label = UILabel()
    label.text = text
    label.textColor = .white
    label.font = .systemFont(ofSize: 12, weight: .semibold)
    label.textAlignment = .center
    container.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
        label.centerXAnchor.constraint(equalTo: container.centerXAnchor)
    ])
}
