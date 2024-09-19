//
//  navigationCustomized.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 4.09.2024.
//

import UIKit

class CustomNavigationBar2: UIView {

    private let notificationAlertButton: UIButton = {
        let button = UIButton(type: .system)
        let notificationButton = UIImage(systemName: "bell")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        button.setImage(notificationButton, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let notificationView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.heightForCustomBar / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#8873CA")
        return view
    }()

    private let searchContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let leftImageBrandLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "n11-navlogo")
        imageView.backgroundColor = UIColor(hex: "#F7CE46")
        imageView.layer.cornerRadius = 6
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.setLeftPaddingPoints(10)
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        textField.attributedPlaceholder = NSAttributedString(
            string: "Ürün, kategori, marka ara",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.font = .systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let searchIconButton: UIButton = {
        let button = UIButton(type: .system)
        let searchIcon = UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        button.setImage(searchIcon, for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let imageBrandLogoContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#F7CE46")

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        configureUI()
    }

    private func setupViews() {
        notificationView.removeFromSuperview()
        imageBrandLogoContainer.removeFromSuperview()
        searchContainerView.removeFromSuperview()

        addSubview(notificationView)
        addSubview(imageBrandLogoContainer)
        addSubview(searchContainerView)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchIconButton)
        imageBrandLogoContainer.addSubview(leftImageBrandLogo)
        notificationView.addSubview(notificationAlertButton)

        NSLayoutConstraint.activate([
            // leftImageBrandLogo ve imageBrandLogoContainer için constraint'ler
            imageBrandLogoContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageBrandLogoContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBrandLogoContainer.heightAnchor.constraint(equalToConstant: 40),
            imageBrandLogoContainer.widthAnchor.constraint(equalToConstant: 80),

            leftImageBrandLogo.leadingAnchor.constraint(equalTo: imageBrandLogoContainer.leadingAnchor, constant: 5),
            leftImageBrandLogo.trailingAnchor.constraint(equalTo: imageBrandLogoContainer.trailingAnchor, constant: -5),
            leftImageBrandLogo.topAnchor.constraint(equalTo: imageBrandLogoContainer.topAnchor, constant: 5),
            leftImageBrandLogo.bottomAnchor.constraint(equalTo: imageBrandLogoContainer.bottomAnchor, constant: -5),

            // searchTextField için constraint'ler
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 0),
            searchTextField.trailingAnchor.constraint(equalTo: searchIconButton.leadingAnchor, constant: -8),
            searchTextField.heightAnchor.constraint(equalTo: searchContainerView.heightAnchor),

            // searchIconButton için constraint'ler
            searchIconButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchIconButton.widthAnchor.constraint(equalToConstant: 24),
            searchIconButton.heightAnchor.constraint(equalToConstant: 24),

            // searchContainerView için constraint'ler
            searchContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchContainerView.leadingAnchor.constraint(equalTo: imageBrandLogoContainer.trailingAnchor, constant: 0),
            searchContainerView.trailingAnchor.constraint(equalTo: notificationView.leadingAnchor, constant: -10),
            searchContainerView.heightAnchor.constraint(equalToConstant: 40),

            // notificationView ve notificationAlertButton için constraint'ler
            notificationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            notificationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            notificationView.heightAnchor.constraint(equalToConstant: Constants.heightForCustomBar),
            notificationView.widthAnchor.constraint(equalToConstant: Constants.heightForCustomBar),

            notificationAlertButton.centerXAnchor.constraint(equalTo: notificationView.centerXAnchor),
            notificationAlertButton.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            notificationAlertButton.heightAnchor.constraint(equalTo: notificationView.heightAnchor),
            notificationAlertButton.widthAnchor.constraint(equalTo: notificationView.widthAnchor)
        ])
    }

    private func configureUI() {
        searchTextField.delegate = self
        searchTextField.performPrimaryAction()
    }
}

extension CustomNavigationBar2: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchTextField.performPrimaryAction()
        return true
    }
}


extension CustomNavigationBar2 {
    enum Constants {
        static let heightForCustomBar: CGFloat = 40
    }
}
