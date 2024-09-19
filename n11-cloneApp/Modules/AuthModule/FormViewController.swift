//
//  FormViewController.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 11.08.2024.

import UIKit
import FirebaseAuth
import FirebaseFirestore
import LocalAuthentication

class FormViewController: UIViewController {

    private var loginButtonTopConstraint: NSLayoutConstraint?
    private var userFormViewHeightConstraint: NSLayoutConstraint?
    private var getSelectedGender: String = "Unknown"

    private var isCheckBoxTapped: Bool = false

    weak var delegate: UserAuthenticationProtocol?

    let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentView()

        userFormViewHeightConstraint = userFormView.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 100)
        userFormViewHeightConstraint?.isActive = true


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        emailTextField.delegate = self
        enterPassTextField.delegate = self

        emailTextField.returnKeyType = .next
        enterPassTextField.returnKeyType = .done


    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isBeingDismissed {
            print("dismissed")
        }

    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "auth")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let userFormView: UIView = {
        let userFormView = UIView()
        userFormView.backgroundColor = .white
        userFormView.translatesAutoresizingMaskIntoConstraints = false
        userFormView.layer.cornerRadius = 8
        return userFormView
    }()

    private let companyLogo: UIImageView = {
        let companyLogoImageView = UIImageView()
        companyLogoImageView.contentMode = .scaleAspectFit
        companyLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        companyLogoImageView.image = UIImage(named: "n11-navlogo")
        return companyLogoImageView
    }()

    private let labelUnderCompanyLogo: UILabel = {
        let labelUnderCompanyLogo = UILabel()
        labelUnderCompanyLogo.text = "Üyelere özel kupon ve fırsatlar seni bekliyor🤗"
        labelUnderCompanyLogo.textColor = .black
        labelUnderCompanyLogo.translatesAutoresizingMaskIntoConstraints = false
        labelUnderCompanyLogo.textAlignment = .center
        labelUnderCompanyLogo.font = .systemFont(ofSize: 14, weight: .light)
        return labelUnderCompanyLogo
    }()

    private let segmentedControlView: UIView = {
        let segmentedView = UIView()
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        segmentedView.layer.cornerRadius = 8
        return segmentedView
    }()

    let segmentedControlChoosable: UISegmentedControl = {
        let segmentItems = ["Giriş Yap", "Üye Ol"]
        let segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.layer.cornerRadius = 8
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(textAttributes, for: .selected)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .darkGray.withAlphaComponent(0.01)

        return segmentedControl
    }()

    private let textFieldContainer: UIView = {
        let textFieldContainer = UIView()
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        return textFieldContainer
    }()

    // MARK: -- LoginSegment

    private let emailTextField: PaddedTextField = {
        let textField = PaddedTextField(placeholder: "E-posta Adresi veya Telefon Numarası")
        return textField
    }()

    private let enterPassTextField: PaddedTextField = {
        let textField = PaddedTextField(placeholder: "Şifre", isSecure: true)
        textField.isHidden = true
        return textField
    }()

    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.tintColor = .white
        loginButton.backgroundColor = UIColor(named: "purple11")
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Giriş Yap", for: .normal)
        loginButton.layer.cornerRadius = 6
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        return loginButton
    }()

    private let loginWithFaceID: UIButton = {
        let faceID = UIButton()
        faceID.backgroundColor = .white
        faceID.translatesAutoresizingMaskIntoConstraints = false

        let configurationSymbolColor = UIImage.SymbolConfiguration(hierarchicalColor: .purple11)
        let configurationSymbolSize = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .default)
        let mergedConfiguration = configurationSymbolColor.applying(configurationSymbolSize)
        let image = UIImage(systemName: "faceid")?.withConfiguration(mergedConfiguration)

        faceID.layer.borderColor = UIColor.purple11.cgColor
        faceID.layer.borderWidth = 1
        faceID.setImage(image, for: .normal)
        faceID.imageView?.contentMode = .scaleAspectFill
        faceID.layer.cornerRadius = 6

        return faceID
    }()

    //MARK: -- SignUp Segment ROW 1 --

    private let nameTextField: PaddedTextField = {
        let nameTextField = PaddedTextField(placeholder: "Ad")
        nameTextField.isHidden = true
        return nameTextField
    }()

    private let surnameTextField: PaddedTextField = {
        let surnameTextField = PaddedTextField(placeholder: "Soyad (İsteğe Bağlı)")
        surnameTextField.isHidden = true
        return surnameTextField
    }()

    //MARK: -- ROW 2 --

    private let newEmailTextField: PaddedTextField = {
        let newEmailTextField = PaddedTextField(placeholder: "E-posta Adresi")
        newEmailTextField.isHidden = true
        return newEmailTextField
    }()

    //MARK: -- ROW 3 --

    private let countryPhoneCode: PaddedTextField = {
        let countryPhoneCode = PaddedTextField(placeholder: "")
        countryPhoneCode.text = "TR (+90)"
        countryPhoneCode.font = .systemFont(ofSize: 14, weight: .regular)
        countryPhoneCode.isEnabled = false
        countryPhoneCode.isHidden = true
        return countryPhoneCode
    }()

    private let phoneNumber: PaddedTextField = {
        let phoneNumber = PaddedTextField(placeholder: "Telefon Numarası")
        phoneNumber.isHidden = true
        return phoneNumber
    }()

    //MARK: -- SubView SMS --

    private let informationAuthSMSView: UIView = {
        let infoSMSView = UIView()
        infoSMSView.backgroundColor = UIColor(named: "lightpurple11")
        infoSMSView.translatesAutoresizingMaskIntoConstraints = false
        infoSMSView.layer.cornerRadius = 6
        infoSMSView.isHidden = true

        return infoSMSView
    }()

    private let infoSMSImageView: UIImageView = {
        let infoSMSImage = UIImageView()
        infoSMSImage.image = UIImage(systemName: "exclamationmark.circle.fill")
        infoSMSImage.tintColor = UIColor(named: "purple11")
        infoSMSImage.translatesAutoresizingMaskIntoConstraints = false

        return infoSMSImage
    }()

    private let infoSMSLabel: UILabel = {
        let infoSMSLabel = UILabel()
        infoSMSLabel.text = "Numaranı doğrulaman için SMS ile kod göndereceğiz."
        infoSMSLabel.translatesAutoresizingMaskIntoConstraints = false
        infoSMSLabel.textColor = .black
        infoSMSLabel.font = .systemFont(ofSize: 13, weight: .light)

        return infoSMSLabel
    }()

    //MARK: -- ROW 5 --

    private let newPassword: PaddedTextField = {
        let newPassword = PaddedTextField(placeholder: "Şifre", isSecure: true)
        newPassword.isHidden = true

        return newPassword
    }()

    //MARK: -- SubView PassRules --

    private let passwordRules: UIStackView = {
        let passRules = UIStackView()
        passRules.distribution = .equalSpacing
        passRules.axis = .horizontal
        passRules.alignment = .center
        passRules.spacing = 10
        passRules.isHidden = true
        passRules.translatesAutoresizingMaskIntoConstraints = false
        passRules.layer.cornerRadius = 8

        return passRules
    }()

    private func createPasswordRule(text: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8


        let circleImageView = UIImageView()
        circleImageView.image = UIImage(systemName: "circle.fill")
        circleImageView.tintColor = .gray
        circleImageView.widthAnchor.constraint(equalToConstant: 9).isActive = true

        let label = UILabel()
        label.text = text
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 11)

        stackView.addArrangedSubview(circleImageView)
        stackView.addArrangedSubview(label)

        return stackView
    }

    //MARK: -- ROW 6 --

    private let genderView: UIView = {
        let genderView = UIView()
        genderView.translatesAutoresizingMaskIntoConstraints = false
        genderView.isHidden = true

        return genderView
    }()

    private let genderLabelTop: UILabel = {
        let genderLabelTop = UILabel()
        genderLabelTop.text = "Cinsiyet (İsteğe Bağlı)"
        genderLabelTop.textColor = .black.withAlphaComponent(0.9)
        genderLabelTop.font = .systemFont(ofSize: 12, weight: .regular)
        genderLabelTop.translatesAutoresizingMaskIntoConstraints = false

        return genderLabelTop
    }()

    private let genderMaleButton: UIButton = {
        let genderMaleButton = UIButton()
        genderMaleButton.setTitle("Erkek", for: .normal)
        genderMaleButton.translatesAutoresizingMaskIntoConstraints = false
        genderMaleButton.layer.cornerRadius = 6
        genderMaleButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        genderMaleButton.setTitleColor(.black, for: .normal)
        genderMaleButton.layer.borderColor = CGColor(gray: 0.8, alpha: 0.8)
        genderMaleButton.layer.borderWidth = 1

        return genderMaleButton
    }()

    private let genderFemaleButton: UIButton = {
        let genderFemaleButton = UIButton()
        genderFemaleButton.setTitle("Kadın", for: .normal)
        genderFemaleButton.translatesAutoresizingMaskIntoConstraints = false
        genderFemaleButton.layer.cornerRadius = 6
        genderFemaleButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        genderFemaleButton.setTitleColor(.black, for: .normal)
        genderFemaleButton.layer.borderColor = CGColor(gray: 0.8, alpha: 0.8)
        genderFemaleButton.layer.borderWidth = 1

        return genderFemaleButton
    }()

    private let checkBoxRequired: UIView = {
        let checkBoxView = UIView()
        checkBoxView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxView.isHidden = true

        return checkBoxView
    }()

    private let checkBoxRequiredSecond: UIView = {
        let checkBoxView = UIView()
        checkBoxView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxView.isHidden = true

        return checkBoxView
    }()

    private func createCheckBoxButton(withTintColor color: UIColor) -> UIButton {
        let checkBoxButton = UIButton()
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false

        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "square")?.withConfiguration(imageConfiguration)
        checkBoxButton.setImage(image, for: .normal)
        checkBoxButton.tintColor = color

        checkBoxButton.addTarget(self, action: #selector(handleCheckBoxPressed), for: .touchUpInside)

        return checkBoxButton
    }

    private func createCheckBoxLabel(withText text: String) -> UILabel {
        let checkBoxLabel = UILabel()
        checkBoxLabel.text = text
        checkBoxLabel.textColor = .black
        checkBoxLabel.font = .systemFont(ofSize: 13, weight: .medium)
        checkBoxLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBoxLabel.numberOfLines = 2

        return checkBoxLabel
    }

    private let bottomKVKKRuleLabel: UILabel = {
        let kvkkLabel = UILabel()
        kvkkLabel.font = .systemFont(ofSize: 14, weight: .regular)
        kvkkLabel.textColor = .black
        kvkkLabel.text = "KVKK Kapsamı detaylarına, n11 Müşteri Kişisel Verilerinin İşlenmesine İlişkin Metne sayfamızdan ulaşabilirsiniz."
        kvkkLabel.numberOfLines = 0
        kvkkLabel.translatesAutoresizingMaskIntoConstraints = false
        kvkkLabel.isHidden = true
        return kvkkLabel
    }()

    private let verifyNumberButton: UIButton = {
        let verifyNumberButton = UIButton ()
        verifyNumberButton.tintColor = .white
        verifyNumberButton.backgroundColor = UIColor(named: "purple11")
        verifyNumberButton.translatesAutoresizingMaskIntoConstraints = false
        verifyNumberButton.setTitle("Kayıt Ol", for: .normal)
        verifyNumberButton.layer.cornerRadius = 6
        verifyNumberButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        verifyNumberButton.isHidden = true

        return verifyNumberButton
    }()

    @objc private func registerButtonTapped() {
        guard let email = newEmailTextField.text, !email.isEmpty,
              let password = newPassword.text, !password.isEmpty else {
            print("Email ve şifreyi doldurmalısınız!")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            self.saveAdditionalUserInfo()
        }
    }

    private func saveAdditionalUserInfo() {
        guard let user = Auth.auth().currentUser else {
            print("User is not acitve yet")
            return
        }
        print(getSelectedGender)

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "firstName": nameTextField.text ?? "",
            "lastName": surnameTextField.text ?? "",
            "email": newEmailTextField.text ?? "",
            "phoneNumber": phoneNumber.text ?? "",
            "gender": getSelectedGender,
        ]) { error in
            if let error = error {
                print("Hata \(error.localizedDescription)")
                return
            }
        }
        emailTextField.text = newEmailTextField.text
        segmentedControlChoosable.selectedSegmentIndex = 0
        segmentChanged(segmentedControlChoosable)
    }

    //MARK: -- Functions --

    @objc private func loginButtonTapped() {
        guard let emailField = emailTextField.text, !emailField.isEmpty else {
            self.loginButton.isEnabled = true
            return
        }
        loginButton.isEnabled = false

        if emailTextField.text != nil {
            enterPassTextField.isHidden = false
        }
        else
        {
            enterPassTextField.isHidden = true
        }

        loginButtonTopConstraint?.isActive = false
        loginButtonTopConstraint = loginButton.topAnchor.constraint(equalTo: enterPassTextField.bottomAnchor,
                                                                    constant: 30)
        loginButtonTopConstraint?.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        guard let loginPassField = enterPassTextField.text, !loginPassField.isEmpty else {
            self.loginButton.isEnabled = true
            return
        }

        Auth.auth().signIn(withEmail: emailField, password: loginPassField) { result, error in
            if let error = error {
                print("Check result..")
                print(error.localizedDescription)
                print(emailField)
                print(loginPassField)
                self.loginButton.isEnabled = true
                return
            }

            UserDefaults.standard.set(self.emailTextField.text, forKey: "userEmail")
            UserDefaults.standard.set(self.enterPassTextField.text, forKey: "userPassword")

            self.fetchUserInfo()
        }
    }

    @objc private func faceIDTapped() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "FaceID özelliğini aktifleştirmezsen bu özelliği kullanamzsın."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.signInWithFirebase()
                    } else {
                    }
                }
            }
        } else {
            self.showAlert(title: "Hata", message: "Face ID bu cihazda aktif değil.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    func signInWithFirebase() {
        guard let email = UserDefaults.standard.string(forKey: "userEmail"),
              let password = UserDefaults.standard.string(forKey: "userPassword") else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            self.fetchUserInfo()
        }
    }

    private func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else {
            print("Kullanıcı oturumu açmamış!")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists,
                  let _ = document.data() else {
                print("Doküman bulunamadı!")
                return
            }

            self.delegate?.userDismissedAuthenticaionScreen()

            NotificationCenter.default.post(name: .userDidSignIn, object: nil)
            self.dismiss(animated: true, completion: nil)

            self.loginButton.isEnabled = true
        }
    }


    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let isLoginSegmentSelected = sender.selectedSegmentIndex == 0

        let loginFields = [emailTextField, loginButton, loginWithFaceID]
        let registerFields = [
            nameTextField, surnameTextField, newEmailTextField,
            countryPhoneCode, phoneNumber, informationAuthSMSView,
            newPassword, passwordRules, genderView, checkBoxRequired, checkBoxRequiredSecond,
            bottomKVKKRuleLabel, verifyNumberButton
        ]

        loginFields
            .compactMap { $0 as? UITextField }
            .forEach { $0.delegate = self }

        registerFields
            .compactMap { $0 as? UITextField }
            .filter { $0 != countryPhoneCode }
            .forEach { $0.delegate = self }

        loginFields.forEach { $0.isHidden = !isLoginSegmentSelected}
        registerFields.forEach { $0.isHidden = isLoginSegmentSelected }

        if isLoginSegmentSelected {
            // Remove previous height constraint if exists
            if let previousHeightConstraint = userFormViewHeightConstraint {
                previousHeightConstraint.isActive = false
            }
            userFormViewHeightConstraint = userFormView.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 100)
            userFormViewHeightConstraint?.isActive = true

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            if let previousHeightConstraint = userFormViewHeightConstraint {
                previousHeightConstraint.isActive = false
            }

            userFormViewHeightConstraint = userFormView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            userFormViewHeightConstraint?.isActive = true

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func genderButtonTapped(_ sender: UIButton) {
        if sender == genderMaleButton {
            genderMaleButton.backgroundColor = UIColor(named: "lightpurple11")
            genderMaleButton.setTitleColor(UIColor(named: "purple11"), for: .normal)
            genderMaleButton.layer.borderColor = UIColor(named: "purple11")?.cgColor
            genderMaleButton.layer.borderWidth = 1

            genderFemaleButton.setTitleColor(.black, for: .normal)
            genderFemaleButton.layer.borderColor = CGColor(gray: 0.8, alpha: 0.8)
            genderFemaleButton.backgroundColor = .clear
            getSelectedGender = genderMaleButton.currentTitle!
            print(getSelectedGender)
        } else {
            genderFemaleButton.backgroundColor = UIColor(named: "lightpurple11")
            genderFemaleButton.setTitleColor(UIColor(named: "purple11"), for: .normal)
            genderFemaleButton.layer.borderColor = UIColor(named: "purple11")?.cgColor
            genderFemaleButton.layer.borderWidth = 1

            genderMaleButton.setTitleColor(.black, for: .normal)
            genderMaleButton.layer.borderColor = CGColor(gray: 0.8, alpha: 0.8)
            genderMaleButton.backgroundColor = .clear
            getSelectedGender = genderFemaleButton.currentTitle!
            print(getSelectedGender)
        }
    }

    @objc private func handleCheckBoxPressed(_ sender: UIButton) {
        sender.isSelected.toggle()

        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let imageName = sender.isSelected ? "checkmark.square.fill" : "square"
        let image = UIImage(systemName: imageName)?.withConfiguration(imageConfiguration)

        sender.setImage(image, for: .normal)
        sender.tintColor = UIColor(named: "purple11")
    }

    private func setupContentView() {

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(hex: "#eeeff3")
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor(hex: "#eeeff3")
        scrollView.addSubview(contentView)

        let passRuleNo1 = createPasswordRule(text: "En az 1 rakam")
        let passRuleNo2 = createPasswordRule(text: "6 - 15 karakter")
        let passRuleNo3 = createPasswordRule(text: "En az 1 harf")

        let checkBox1 = createCheckBoxButton(withTintColor: UIColor(named: "purple11")!)
        let checkBox1Label = createCheckBoxLabel(withText: "Üyelik sözleşmesi şartlarını okudum ve kabul ediyorum.")

        let checkBox2 = createCheckBoxButton(withTintColor: UIColor(named: "purple11")!)
        let checkBox2Label = createCheckBoxLabel(
            withText: "n11'in bana özel sunduğu kampanya ve fırsatlardan haberdar olmak istiyorum.")

        segmentedControlChoosable.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        genderMaleButton.addTarget(self, action: #selector(genderButtonTapped), for: .touchUpInside)
        genderFemaleButton.addTarget(self, action: #selector(genderButtonTapped), for: .touchUpInside)
        verifyNumberButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginWithFaceID.addTarget(self, action: #selector(faceIDTapped), for: .touchUpInside)


        contentView.addSubview(backgroundImage)
        contentView.addSubview(userFormView)
        contentView.addSubview(segmentedControlView)

        userFormView.addSubview(companyLogo)
        userFormView.addSubview(labelUnderCompanyLogo)

        segmentedControlView.addSubview(segmentedControlChoosable)
        segmentedControlView.addSubview(textFieldContainer)

        textFieldContainer.addSubview(emailTextField)
        textFieldContainer.addSubview(enterPassTextField)
        textFieldContainer.addSubview(loginButton)
        textFieldContainer.addSubview(loginWithFaceID)
        textFieldContainer.addSubview(nameTextField)
        textFieldContainer.addSubview(surnameTextField)
        textFieldContainer.addSubview(newEmailTextField)
        textFieldContainer.addSubview(countryPhoneCode)
        textFieldContainer.addSubview(phoneNumber)
        textFieldContainer.addSubview(informationAuthSMSView)
        informationAuthSMSView.addSubview(infoSMSImageView)
        informationAuthSMSView.addSubview(infoSMSLabel)

        textFieldContainer.addSubview(newPassword)
        textFieldContainer.addSubview(passwordRules)

        textFieldContainer.addSubview(genderView)
        genderView.addSubview(genderLabelTop)

        genderView.addSubview(genderMaleButton)
        genderView.addSubview(genderFemaleButton)

        textFieldContainer.addSubview(checkBoxRequired)
        textFieldContainer.addSubview(checkBoxRequiredSecond)
        checkBoxRequired.addSubview(checkBox1)
        checkBoxRequired.addSubview(checkBox1Label)

        checkBoxRequiredSecond.addSubview(checkBox2)
        checkBoxRequiredSecond.addSubview(checkBox2Label)

        passwordRules.addArrangedSubview(passRuleNo1)
        passwordRules.addArrangedSubview(passRuleNo2)
        passwordRules.addArrangedSubview(passRuleNo3)

        textFieldContainer.addSubview(bottomKVKKRuleLabel)
        textFieldContainer.addSubview(verifyNumberButton)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            userFormView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 50),
            userFormView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userFormView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            companyLogo.topAnchor.constraint(equalTo: userFormView.topAnchor, constant: 10),
            companyLogo.leadingAnchor.constraint(equalTo: userFormView.leadingAnchor),
            companyLogo.trailingAnchor.constraint(equalTo: userFormView.trailingAnchor),
            companyLogo.heightAnchor.constraint(equalToConstant: 44),

            labelUnderCompanyLogo.topAnchor.constraint(equalTo: companyLogo.bottomAnchor, constant: 25),
            labelUnderCompanyLogo.leadingAnchor.constraint(equalTo: userFormView.leadingAnchor),
            labelUnderCompanyLogo.trailingAnchor.constraint(equalTo: userFormView.trailingAnchor),

            segmentedControlView.topAnchor.constraint(equalTo: labelUnderCompanyLogo.bottomAnchor, constant: 10),
            segmentedControlView.leadingAnchor.constraint(equalTo: userFormView.leadingAnchor),
            segmentedControlView.trailingAnchor.constraint(equalTo: userFormView.trailingAnchor),
            segmentedControlView.bottomAnchor.constraint(equalTo: userFormView.bottomAnchor),

            segmentedControlChoosable.topAnchor.constraint(equalTo: segmentedControlView.topAnchor, constant: 10),
            segmentedControlChoosable.leadingAnchor.constraint(equalTo: segmentedControlView.leadingAnchor,
                                                               constant: 10),
            segmentedControlChoosable.trailingAnchor.constraint(equalTo: segmentedControlView.trailingAnchor,
                                                                constant: -10),
            segmentedControlChoosable.heightAnchor.constraint(equalToConstant: 50),

            textFieldContainer.topAnchor.constraint(equalTo: segmentedControlChoosable.bottomAnchor, constant: 20),
            textFieldContainer.leadingAnchor.constraint(equalTo: segmentedControlView.leadingAnchor, constant: 12),
            textFieldContainer.trailingAnchor.constraint(equalTo: segmentedControlView.trailingAnchor, constant: -12),
            textFieldContainer.bottomAnchor.constraint(equalTo: segmentedControlView.bottomAnchor, constant: -10),

            //MARK: SegmentLogin
            emailTextField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.heightForTextFields),

            enterPassTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,
                                                    constant: Constants.spaceBetweenTextFieldsVertically),
            enterPassTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            enterPassTextField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            enterPassTextField.heightAnchor.constraint(equalToConstant: Constants.heightForTextFields),

            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: Constants.heightForTextFields),

            loginWithFaceID.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            loginWithFaceID.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loginWithFaceID.widthAnchor.constraint(equalToConstant: segmentedControlChoosable.bounds.width / 2),
            loginWithFaceID.heightAnchor.constraint(equalToConstant: Constants.heightForTextFields),

            //MARK: SegmentSignUp
            nameTextField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.heightForTextFields),
            nameTextField.widthAnchor.constraint(equalTo: enterPassTextField.widthAnchor, multiplier: (1/2),
                                                 constant: -Constants.spaceBetweenTextFieldsHorizontally),

            surnameTextField.topAnchor.constraint(equalTo: nameTextField.topAnchor),
            surnameTextField.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            surnameTextField.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            surnameTextField.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor,
                                                      constant: Constants.spaceBetweenTextFieldsHorizontally),

            newEmailTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            newEmailTextField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            newEmailTextField.heightAnchor.constraint(equalToConstant: Constants.heightForTextFields),
            newEmailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                                   constant: Constants.spaceBetweenTextFieldsVertically),

            countryPhoneCode.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            countryPhoneCode.heightAnchor.constraint(equalToConstant: Constants.heightForTextFields),
            countryPhoneCode.widthAnchor.constraint(equalTo: phoneNumber.widthAnchor, multiplier: 2/5),
            countryPhoneCode.topAnchor.constraint(equalTo: newEmailTextField.bottomAnchor,
                                                  constant: Constants.spaceBetweenTextFieldsVertically),

            phoneNumber.topAnchor.constraint(equalTo: countryPhoneCode.topAnchor),
            phoneNumber.leadingAnchor.constraint(equalTo: countryPhoneCode.trailingAnchor,
                                                 constant: Constants.spaceBetweenTextFieldsHorizontally),
            phoneNumber.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            phoneNumber.heightAnchor.constraint(equalTo: countryPhoneCode.heightAnchor),

            informationAuthSMSView.heightAnchor.constraint(equalToConstant: Constants.infoSMSVerificationView),
            informationAuthSMSView.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            informationAuthSMSView.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            informationAuthSMSView.topAnchor.constraint(equalTo: countryPhoneCode.bottomAnchor,
                                                        constant: Constants.spaceBetweenTextFieldsVertically),

            infoSMSImageView.leadingAnchor.constraint(equalTo: informationAuthSMSView.leadingAnchor, constant: 10),
            infoSMSImageView.centerYAnchor.constraint(equalTo: informationAuthSMSView.centerYAnchor),
            infoSMSImageView.widthAnchor.constraint(equalToConstant: Constants.infoSMSVerificationView / 2),
            infoSMSImageView.heightAnchor.constraint(equalToConstant: Constants.infoSMSVerificationView / 2),

            infoSMSLabel.leadingAnchor.constraint(equalTo: infoSMSImageView.trailingAnchor, constant: 10),
            infoSMSLabel.trailingAnchor.constraint(equalTo: informationAuthSMSView.trailingAnchor),
            infoSMSLabel.centerYAnchor.constraint(equalTo: infoSMSImageView.centerYAnchor),
            //MARK: --Info End --

            newPassword.topAnchor.constraint(equalTo: informationAuthSMSView.bottomAnchor,
                                             constant: Constants.spaceBetweenTextFieldsVertically),
            newPassword.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            newPassword.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            newPassword.heightAnchor.constraint(equalToConstant: Constants.heightForTextFields),

            passwordRules.topAnchor.constraint(equalTo: newPassword.bottomAnchor,
                                               constant: 10),
            passwordRules.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 30),
            passwordRules.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -30),
            passwordRules.heightAnchor.constraint(equalToConstant: 9),
            //MARK: Password End --

            genderView.topAnchor.constraint(equalTo: passwordRules.bottomAnchor, constant: 15),
            genderView.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            genderView.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            genderView.heightAnchor.constraint(equalToConstant: 80),

            genderLabelTop.topAnchor.constraint(equalTo: genderView.topAnchor, constant: 5),
            genderLabelTop.leadingAnchor.constraint(equalTo: genderView.leadingAnchor),
            genderLabelTop.trailingAnchor.constraint(equalTo: genderView.trailingAnchor),
            genderLabelTop.heightAnchor.constraint(equalToConstant: 13),

            genderFemaleButton.topAnchor.constraint(equalTo: genderLabelTop.bottomAnchor, constant: 10),
            genderFemaleButton.leadingAnchor.constraint(equalTo: genderView.leadingAnchor),
            genderFemaleButton.bottomAnchor.constraint(equalTo: genderView.bottomAnchor, constant: -1),
            genderFemaleButton.widthAnchor.constraint(equalTo: genderMaleButton.widthAnchor, multiplier: 1),

            genderMaleButton.topAnchor.constraint(equalTo: genderFemaleButton.topAnchor),
            genderMaleButton.trailingAnchor.constraint(equalTo: genderView.trailingAnchor),
            genderMaleButton.bottomAnchor.constraint(equalTo: genderFemaleButton.bottomAnchor),
            genderMaleButton.leadingAnchor.constraint(equalTo: genderFemaleButton.trailingAnchor, constant: 10),

            checkBoxRequired.topAnchor.constraint(equalTo: genderView.bottomAnchor, constant: 10),
            checkBoxRequired.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            checkBoxRequired.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            checkBoxRequired.heightAnchor.constraint(equalToConstant: 40),

            checkBox1.centerYAnchor.constraint(equalTo: checkBoxRequired.centerYAnchor),
            checkBox1.leadingAnchor.constraint(equalTo: checkBoxRequired.leadingAnchor),
            checkBox1.widthAnchor.constraint(equalToConstant: 40),

            checkBox1Label.leadingAnchor.constraint(equalTo: checkBox1.trailingAnchor),
            checkBox1Label.topAnchor.constraint(equalTo: checkBoxRequired.topAnchor),
            checkBox1Label.bottomAnchor.constraint(equalTo: checkBoxRequired.bottomAnchor),
            checkBox1Label.trailingAnchor.constraint(equalTo: checkBoxRequired.trailingAnchor),

            checkBoxRequiredSecond.topAnchor.constraint(equalTo: checkBoxRequired.bottomAnchor, constant: 10),
            checkBoxRequiredSecond.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            checkBoxRequiredSecond.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            checkBoxRequiredSecond.heightAnchor.constraint(equalToConstant: 40),

            checkBox2.centerYAnchor.constraint(equalTo: checkBoxRequiredSecond.centerYAnchor),
            checkBox2.leadingAnchor.constraint(equalTo: checkBoxRequiredSecond.leadingAnchor),
            checkBox2.widthAnchor.constraint(equalToConstant: 40),

            checkBox2Label.leadingAnchor.constraint(equalTo: checkBox2.trailingAnchor),
            checkBox2Label.topAnchor.constraint(equalTo: checkBoxRequiredSecond.topAnchor),
            checkBox2Label.bottomAnchor.constraint(equalTo: checkBoxRequiredSecond.bottomAnchor),
            checkBox2Label.trailingAnchor.constraint(equalTo: checkBoxRequiredSecond.trailingAnchor),

            bottomKVKKRuleLabel.topAnchor.constraint(equalTo: checkBoxRequiredSecond.bottomAnchor, constant: 10),
            bottomKVKKRuleLabel.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            bottomKVKKRuleLabel.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            bottomKVKKRuleLabel.heightAnchor.constraint(equalToConstant: 52),

            verifyNumberButton.topAnchor.constraint(equalTo: bottomKVKKRuleLabel.bottomAnchor,constant: 10),
            verifyNumberButton.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor),
            verifyNumberButton.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor),
            verifyNumberButton.heightAnchor.constraint(equalToConstant: 52),

            contentView.bottomAnchor.constraint(equalTo: verifyNumberButton.bottomAnchor, constant: 20)
        ])

        loginButtonTopConstraint = loginButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30)
        loginButtonTopConstraint?.isActive = true
    }
}

extension FormViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == enterPassTextField {
            textField.resignFirstResponder()
            return true
        }

        if textField == emailTextField {
            if emailTextField.text != "" {
                enterPassTextField.isHidden = false
                loginButtonTopConstraint?.isActive = false
                loginButtonTopConstraint = loginButton.topAnchor.constraint(equalTo: enterPassTextField.bottomAnchor,
                                                                            constant: 30)
                loginButtonTopConstraint?.isActive = true

                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                    self.enterPassTextField.becomeFirstResponder()
                }
            }
            else
            {
                enterPassTextField.isHidden = true
            }
        }

        let textFields = getAllTextFields(from: view)
        if let currentIndex = textFields.firstIndex(of: textField) {
            let nextIndex = currentIndex + 1
            if nextIndex < textFields.count {
                let nextTextField = textFields[nextIndex]
                if nextTextField == enterPassTextField
                {
                    if emailTextField.text != "" {
                        nextTextField.becomeFirstResponder()
                    }
                    else
                    {
                        emailTextField.becomeFirstResponder()
                    }
                }
                else
                {
                    nextTextField.becomeFirstResponder()
                }
            } else {
                textField.resignFirstResponder()
            }
        }
        return true
    }

    private func getAllTextFields(from view: UIView) -> [UITextField] {
        var textFields: [UITextField] = []
        for subview in view.subviews {
            if let textField = subview as? UITextField, textField != countryPhoneCode {
                textFields.append(textField)
            }
            textFields.append(contentsOf: getAllTextFields(from: subview))
        }
        return textFields
    }
}

extension FormViewController {
    private enum Constants {
        static let heightForTextFields: CGFloat = 52
        static let spaceBetweenTextFieldsVertically: CGFloat = 20
        static let spaceBetweenTextFieldsHorizontally: CGFloat = 16
        static let infoSMSVerificationView: CGFloat = 36
    }
}
