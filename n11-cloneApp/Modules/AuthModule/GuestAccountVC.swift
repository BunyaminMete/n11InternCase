//
//  GuestAccountVC.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 1.08.2024.
//

import UIKit

class GuestAccountVC: UIViewController {

    let titleLabel = UILabel()
    let separator = UIView()
    let contentView = UIView()
    let multilineLabel = UILabel()
    let signUpButton = UIButton(type: .system)
    let loginButton = UIButton(type: .system)
    let separatorSecond = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.view.backgroundColor = .white
    }

    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    private func configureUI() {
        // MARK:  - Navigation Bar
        let customNavigationBar = OtherNavigationBar()
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavigationBar)

        customNavigationBar.configure(withTitle: "Hesabım")

        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // MARK: First Seperator
        separator.backgroundColor = .systemGray
        separator.alpha = 0.1
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: customNavigationBar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: customNavigationBar.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 8),
            separator.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        // MARK: - UIView for Authentication
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            contentView.heightAnchor.constraint(equalToConstant: 180)
        ])
       
        multilineLabel.numberOfLines = 0
        multilineLabel.text = "Sana özel kampanyalardan & kuponlardan yararlanmak ve siparişlerinin durumunu takip etmek için giriş yap."
        multilineLabel.textColor = .black
        multilineLabel.font = .systemFont(ofSize: 14, weight: .light)
        multilineLabel.textAlignment = .left
        multilineLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(multilineLabel)
        
        NSLayoutConstraint.activate([
            multilineLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            multilineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            multilineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        let hexColorPurple = UIColor(hex: "5D3BBB")
        
        // MARK: UIButtons
       
        signUpButton.setTitle("Üye Ol", for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.tintColor = hexColorPurple
        signUpButton.layer.borderColor = hexColorPurple.cgColor
        signUpButton.layer.borderWidth = 1
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)

        signUpButton.layer.cornerRadius = 10
        
        contentView.addSubview(signUpButton)
        
        
        loginButton.setTitle("Giriş Yap", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor(named: "purple11")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.layer.cornerRadius = 10
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        contentView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: multilineLabel.bottomAnchor, constant: 5),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: loginButton.leadingAnchor, constant: -10),
            signUpButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: multilineLabel.bottomAnchor, constant: 5),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        
        // MARK: - Second Seperator
       
        separatorSecond.backgroundColor = .systemGray
        separatorSecond.alpha = 0.1
        separatorSecond.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorSecond)

        NSLayoutConstraint.activate([
            separatorSecond.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorSecond.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorSecond.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            separatorSecond.heightAnchor.constraint(equalToConstant: 8) // Separator yüksekliği
        ])
        
        // MARK: Help Panel
        
    }
    
    @objc private func signUpTapped() {
        let formVC = FormViewController()
        present(formVC, animated: true, completion: nil )
    }    
}
