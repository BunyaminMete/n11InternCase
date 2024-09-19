//
//  OtherNavigationBar.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 12.08.2024.
//
import UIKit

class OtherNavigationBar: UIView {

    private let customNavigationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let magnifyingGlassButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "magnifyingglass")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let deleteProductsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "trash")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    private let navbarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .purple11
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContainer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContainer()
    }

    private func configureContainer() {
        addSubview(navbarContainer)
        navbarContainer.addSubview(customNavigationLabel)
        navbarContainer.addSubview(magnifyingGlassButton)
        navbarContainer.addSubview(deleteProductsButton)

        NSLayoutConstraint.activate([
            // Navbar container constraints
            navbarContainer.topAnchor.constraint(equalTo: topAnchor),
            navbarContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            navbarContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            navbarContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            navbarContainer.heightAnchor.constraint(equalToConstant: 120),

            // Label constraints (ortada olacak şekilde hizalama)
            customNavigationLabel.centerXAnchor.constraint(equalTo: navbarContainer.centerXAnchor),
            customNavigationLabel.bottomAnchor.constraint(equalTo: navbarContainer.bottomAnchor, constant: -20),

            // Magnifying glass button constraints (sağa hizalama)
            magnifyingGlassButton.trailingAnchor.constraint(equalTo: navbarContainer.trailingAnchor, constant: -16),
            magnifyingGlassButton.bottomAnchor.constraint(equalTo: navbarContainer.bottomAnchor, constant: -20),
            magnifyingGlassButton.widthAnchor.constraint(equalToConstant: 24),
            magnifyingGlassButton.heightAnchor.constraint(equalToConstant: 24),

            deleteProductsButton.trailingAnchor.constraint(equalTo: navbarContainer.trailingAnchor, constant: -16),
            deleteProductsButton.topAnchor.constraint(equalTo: customNavigationLabel.topAnchor),
            deleteProductsButton.bottomAnchor.constraint(equalTo: customNavigationLabel.bottomAnchor)
        ])
    }

    func configure(withTitle title: String) {
        customNavigationLabel.text = title
        if title == "Sepetim" {
            deleteProductsButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
            deleteProductsButton.heightAnchor.constraint(equalToConstant: 24).isActive = true

            deleteProductsButton.isHidden = false
            magnifyingGlassButton.isHidden = true
        }

        if title == "Favorilerim" || title == "Siparişlerim"{
            magnifyingGlassButton.isHidden = true
        }

        if title  == "Hesabım" {
            magnifyingGlassButton.isHidden = true
            navbarContainer.backgroundColor = .white
            customNavigationLabel.textColor = .black
            customNavigationLabel.font = .systemFont(ofSize: 20, weight: .medium)
        }
    }
}
