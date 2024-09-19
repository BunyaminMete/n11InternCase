//
//  AuthModuleAddressCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.09.2024.
//

import UIKit

protocol AddressCellDelegate: AnyObject {
    func didTapTrashButton(in cell: AddressCell)
}

class AddressCell: UICollectionViewCell {

    static let reuseIdentifier = "AddressCell"
    weak var delegate: AddressCellDelegate?

    // Görseller ve etiketler
    private let addressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "house_address")
        imageView.image = image
        return imageView
    }()

    private let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let addressFullLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0 // Çok satırlı olabilir
        return label
    }()

    private let trashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(addressImageView)
        contentView.addSubview(addressTitleLabel)
        contentView.addSubview(addressFullLabel)
        contentView.addSubview(trashButton)
        contentView.backgroundColor = .purple11
        contentView.layer.cornerRadius = 6

        trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: AddressModel) {
        addressTitleLabel.text = model.addressTitle
        addressFullLabel.text = model.addressFull
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addressImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addressImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addressImageView.widthAnchor.constraint(equalToConstant: 24),
            addressImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            addressTitleLabel.leadingAnchor.constraint(equalTo: addressImageView.trailingAnchor, constant: 10),
            addressTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            addressTitleLabel.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor, constant: -5)
        ])

        NSLayoutConstraint.activate([
            addressFullLabel.leadingAnchor.constraint(equalTo: addressTitleLabel.leadingAnchor),
            addressFullLabel.topAnchor.constraint(equalTo: addressTitleLabel.bottomAnchor, constant: 2),
            addressFullLabel.trailingAnchor.constraint(equalTo: addressTitleLabel.trailingAnchor),
            addressFullLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            trashButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trashButton.centerYAnchor.constraint(equalTo: addressImageView.centerYAnchor),
            trashButton.widthAnchor.constraint(equalToConstant: 30),
            trashButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func trashButtonTapped() {
            delegate?.didTapTrashButton(in: self)
            print("ses")
        }

}
