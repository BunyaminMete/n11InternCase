//
//  PaddedTextField.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 30.08.2024.

import UIKit

class PaddedTextField: UITextField {
    private let padding: CGFloat = 10
    private var isPasswordVisible: Bool = false
    private var togglePasswordButton: UIButton!
    private var floatingLabel: UILabel!
    private var isLabelFloating: Bool = false

    // Initialize with placeholder and secure option
    init(placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        setupFloatingLabel(placeholder: placeholder)
        configureTextField(isSecure: isSecure)

        if let text = self.text, !text.isEmpty {
            animateFloatingLabel(up: true)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Setting up floating label
    private func setupFloatingLabel(placeholder: String) {
        floatingLabel = UILabel()
        floatingLabel.text = placeholder
        floatingLabel.font = UIFont.systemFont(ofSize: 15)
        floatingLabel.textColor = UIColor(hex: "#73829F")
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.alpha = 1 // Initially fully visible to match the placeholder

        addSubview(floatingLabel)

        NSLayoutConstraint.activate([
            floatingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            floatingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor) // Align initially with the placeholder
        ])
    }

    // Text field basic configuration
    private func configureTextField(isSecure: Bool) {
        self.textColor = .black
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6
        self.translatesAutoresizingMaskIntoConstraints = false

        if isSecure {
            self.isSecureTextEntry = true
            configureTogglePasswordButton()
        }

        // Add target to handle editing events
        self.addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
        self.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
    }

    // Override text property to trigger floating label animation
    override var text: String? {
        didSet {
            if let text = text, !text.isEmpty {
                animateFloatingLabel(up: true)
            } else {
                animateFloatingLabel(up: false)
            }
        }
    }

    // Customizing text field rectangle to add padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding,
                      y: bounds.origin.y,
                      width: bounds.size.width - padding - Constants.sizeOfExactWidth,
                      height: bounds.size.height)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding,
                      y: bounds.origin.y,
                      width: bounds.size.width - padding - Constants.sizeOfExactWidth,
                      height: bounds.size.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    // Toggle password button for secure text entry fields
    private func configureTogglePasswordButton() {
        togglePasswordButton = UIButton(type: .custom)
        var buttonConfiguration = UIButton.Configuration.plain()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .medium)

        buttonConfiguration.image = UIImage(systemName: "eye.slash", withConfiguration: imageConfiguration)
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.imagePlacement = .trailing
        buttonConfiguration.buttonSize = .mini

        togglePasswordButton.configuration = buttonConfiguration
        togglePasswordButton.tintColor = .gray
        togglePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        rightView = togglePasswordButton
        rightViewMode = .always
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        self.isSecureTextEntry = !isPasswordVisible
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        togglePasswordButton.setImage(UIImage(systemName: imageName, withConfiguration: imageConfiguration), for: .normal)
    }

    // Animate floating label upwards
    @objc private func handleEditingDidBegin() {
        animateFloatingLabel(up: true)
    }

    // Handle when editing ends
    @objc private func handleEditingDidEnd() {
        if self.text?.isEmpty == true {
            animateFloatingLabel(up: false)
        }
    }

    // Detect text changes to control the floating label
    @objc func handleTextChanged() {
        if let text = self.text, !text.isEmpty {
            if !isLabelFloating {
                animateFloatingLabel(up: true)
            }
        } else {
            if isLabelFloating {
                animateFloatingLabel(up: false)
            }
        }
    }

    // Floating label animation logic
    private func animateFloatingLabel(up: Bool) {
        UIView.animate(withDuration: 0.3) {
            if up {
                self.floatingLabel.font = UIFont.systemFont(ofSize: 12)
                self.floatingLabel.textColor = .purple11
                self.floatingLabel.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height / 2 + 10)
            } else {
                self.floatingLabel.font = UIFont.systemFont(ofSize: 15)
                self.floatingLabel.textColor = UIColor(hex: "#73829F")
                self.floatingLabel.transform = .identity
            }
        }
        isLabelFloating = up
    }
}

extension PaddedTextField {
    private enum Constants {
        static let sizeOfExactWidth: CGFloat = 30
    }
}
