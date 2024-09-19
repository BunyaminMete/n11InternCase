//
//  SubLabelCollectionViewCellProgarammaticCollectionViewCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 9.09.2024.

import UIKit
import FirebaseAuth

class SubLabelProgrammaticCollectionViewCell: UICollectionViewCell {
    static let headerIdentifier = "SubLabelProgrammaticCollectionViewCell"

    weak var delegate: SubLabelProgrammaticCollectionViewCellDelegate?

    // Kullanıcı giriş yapıp yapmadığını kontrol eden flag
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    //NOT LOGGED IN
    private let createOrRegisterLabel: UILabel = {
        let label = UILabel()
        label.text = "⚡️ Üye Ol / Giriş Yap"
        label.textColor = UIColor(named: "purple11")
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let willMergeWithRegisterLabel: UILabel = {
        let label = UILabel()
        label.text = "fırsatları kaçırma!"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // LOGGED IN
    private let locationIconLabel: UILabel = {
        let label = UILabel()
        label.text = "📍"  // Konum sembolü
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addressInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Adres Bilgisi"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let myAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Yakında Güncellenecek!"
        label.backgroundColor = .purple11
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()
        updateLabelsForUserState() // Başlangıç durumu için kontrol
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTapGesture()
        updateLabelsForUserState()
    }

    //*************** RECREATE HERE ****************\\

    // Label'ları duruma göre güncelleyen fonksiyon
    private func updateLabelsForUserState() {
        createOrRegisterLabel.removeFromSuperview()
        willMergeWithRegisterLabel.removeFromSuperview()
        locationIconLabel.removeFromSuperview()
        addressInfoLabel.removeFromSuperview()
        myAddressLabel.removeFromSuperview()

        if isUserLoggedIn {
            addSubview(locationIconLabel)
            addSubview(addressInfoLabel)
            addSubview(myAddressLabel)

            NSLayoutConstraint.activate([
                locationIconLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                locationIconLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                addressInfoLabel.leadingAnchor.constraint(equalTo: locationIconLabel.trailingAnchor, constant: 5),
                addressInfoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                myAddressLabel.leadingAnchor.constraint(equalTo: addressInfoLabel.trailingAnchor, constant: 5),
                myAddressLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        } else {
            addSubview(createOrRegisterLabel)
            addSubview(willMergeWithRegisterLabel)

            NSLayoutConstraint.activate([
                createOrRegisterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                createOrRegisterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                willMergeWithRegisterLabel.leadingAnchor.constraint(equalTo: createOrRegisterLabel.trailingAnchor, constant: 10),
                willMergeWithRegisterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func didTapCell() {
        delegate?.didTapCreateOrRegister()
    }
}
