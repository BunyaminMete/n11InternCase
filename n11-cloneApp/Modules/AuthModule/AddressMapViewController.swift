//  AddressMapViewController.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.09.2024.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore

class AddressMapViewController: UIViewController {

    private var mapViewManager: MapViewManager?
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchResults: [MKLocalSearchCompletion] = []
    private var selectedAddress: UserAddressModel?

    private var postalCode: String? = ""
    var totalHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        mapViewManager = MapViewManager(mapView: mapView)
        mapView.delegate = mapViewManager
        mapViewManager?.delegate = self

        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self

        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.backgroundColor = .white

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        createFakeNavigationComponent(color: .purple11, height: totalHeight, view: view)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaInsets = view.safeAreaInsets
        totalHeight = safeAreaInsets.top
    }

    private func setupUI() {
        setNavigationBar()
        setupSearchContainer()
        setupMapView()
    }

    private func setNavigationBar() {
        navigationItem.title = "Yeni Adres Ekle"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "purple11")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]

        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let backButtonImage = UIImage(systemName: "xmark")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large))

        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    private let searchContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "purple11")
        return view
    }()

    private let innerSearchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()

    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "magnifyingglass")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        imageView.tintColor = .purple11
        return imageView
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let placeholderText = "Adresini ara"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.mapfieldcolor
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.textColor = .black
        return textField
    }()

    private let resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.overrideUserInterfaceStyle = .light
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private let continueWithAddressButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6

        return view
    }()

    private let buttonUIView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple11
        view.layer.cornerRadius = 6
        view.isUserInteractionEnabled = true

        return view
    }()

    private let sendCurrentAddressDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Devam Et"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white

        return label
    }()

    private let addressFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let addressDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let addressAdditionalInformationContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let additionalInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "İletişim Bilgileri"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .semibold)

        return label
    }()

    private let fillWithDefaultInformations: UIButton = {
        let fillButton = UIButton()
        fillButton.translatesAutoresizingMaskIntoConstraints = false
        fillButton.backgroundColor = UIColor(named: "purple11")
        fillButton.setTitle("Kayıtlı Bilgilerini Kullan", for: .normal)
        fillButton.setTitleColor(.white, for: .normal)
        fillButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)

        fillButton.layer.cornerRadius = 2

        return fillButton
    }()

    private let addressCityField: PaddedTextField = PaddedTextField(placeholder: "İl *")
    private let addressDistrictField: PaddedTextField = PaddedTextField(placeholder: "İlçe *")
    private let addressStreetField: PaddedTextField = PaddedTextField(placeholder: "Mahalle / Cadde / Sokak *")
    private let addressStructureNoField: PaddedTextField = PaddedTextField(placeholder: "Bina No *")
    private let addressFloorNumberField: PaddedTextField = PaddedTextField(placeholder: "Kat")
    private let addressApartmentNumberField: PaddedTextField = PaddedTextField(placeholder: "Daire No")
    private let addressDirectionField: PaddedTextField = PaddedTextField(placeholder: "Adres Tarifi")

    private let additionalInfoContactNameTF: PaddedTextField = PaddedTextField(placeholder: "Adınız")
    private let additionalInfoContactSurnameTF: PaddedTextField = PaddedTextField(placeholder: "Soyadınız")
    private let additionalInfoContactPhoneNoTF: PaddedTextField = PaddedTextField(placeholder: "Telefon Numaranız")

    private func setupSearchContainer() {
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(innerSearchView)
        innerSearchView.addSubview(searchImageView)
        innerSearchView.addSubview(searchTextField)
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultsTableView)


        NSLayoutConstraint.activate([
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1),
            searchContainerView.heightAnchor.constraint(equalToConstant: 70),

            innerSearchView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 20),
            innerSearchView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -20),
            innerSearchView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
            innerSearchView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -10),

            searchImageView.leadingAnchor.constraint(equalTo: innerSearchView.leadingAnchor, constant: 10),
            searchImageView.centerYAnchor.constraint(equalTo: innerSearchView.centerYAnchor),
            searchImageView.widthAnchor.constraint(equalToConstant: 24),
            searchImageView.heightAnchor.constraint(equalToConstant: 24),

            searchTextField.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 5),
            searchTextField.trailingAnchor.constraint(equalTo: innerSearchView.trailingAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: innerSearchView.centerYAnchor),

            resultsTableView.leadingAnchor.constraint(equalTo: innerSearchView.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: innerSearchView.trailingAnchor),
            resultsTableView.topAnchor.constraint(equalTo: innerSearchView.bottomAnchor, constant: -8),
            resultsTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupMapView() { //en başta çalışır
        view.addSubview(mapView)
        view.addSubview(continueWithAddressButtonView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidSelectedAddress))
        buttonUIView.addGestureRecognizer(tapGesture)

        let tapGestureForMapView = UITapGestureRecognizer(target: self, action: #selector(userDidSelectMapView))
        mapView.addGestureRecognizer(tapGestureForMapView)

        continueWithAddressButtonView.addSubview(buttonUIView)
        buttonUIView.addSubview(sendCurrentAddressDataLabel)
        
        view.bringSubviewToFront(continueWithAddressButtonView)
        view.bringSubviewToFront(searchContainerView)
        view.bringSubviewToFront(resultsTableView)
        view.sendSubviewToBack(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo:view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.bounds.height - 70),

            continueWithAddressButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            continueWithAddressButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            continueWithAddressButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            buttonUIView.leadingAnchor.constraint(equalTo: continueWithAddressButtonView.leadingAnchor, constant: 20),
            buttonUIView.trailingAnchor.constraint(equalTo: continueWithAddressButtonView.trailingAnchor, constant: -20),
            buttonUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buttonUIView.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            sendCurrentAddressDataLabel.centerXAnchor.constraint(equalTo: buttonUIView.centerXAnchor),
            sendCurrentAddressDataLabel.centerYAnchor.constraint(equalTo: buttonUIView.centerYAnchor)
        ])

        continueWithAddressButtonView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}

// MARK: - MapViewManagerDelegate
extension AddressMapViewController: MapViewManagerDelegate {
    func mapViewManagerTest(_ manager: MapViewManager, didSelectLocationWith address: String) {
        print("Test address: \(address)")
    }

    @objc private func userDidSelectedAddress() {
        print("address selected")
        resultsTableView.isHidden = true
        if sendCurrentAddressDataLabel.text == "Adresi Kaydet" {
            saveAddressToFirestore()
            sendCurrentAddressDataLabel.isEnabled = false
            return
        } else {
            sendCurrentAddressDataLabel.isEnabled = true
        }


        self.addressFieldContainer.alpha = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.addressFieldContainer.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.addressFieldContainer.alpha = 1.0
            }
        }


        let addressFieldsStackView = UIStackView(arrangedSubviews: [
            addressStructureNoField as UIView,
            addressFloorNumberField as UIView,
            addressApartmentNumberField as UIView
        ])
        addressFieldsStackView.axis = .horizontal
        addressFieldsStackView.alignment = .fill
        addressFieldsStackView.distribution = .fillEqually
        addressFieldsStackView.spacing = 10
        addressFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        fillWithDefaultInformations.addTarget(self, action: #selector(getAuthUserInformations), for: .touchUpInside)

        continueWithAddressButtonView.addSubview(addressFieldContainer)
        addressFieldContainer.addSubview(addressCityField)
        addressFieldContainer.addSubview(addressDistrictField)
        addressFieldContainer.addSubview(addressStreetField)
        addressFieldContainer.addSubview(addressFieldsStackView)
        addressFieldContainer.addSubview(addressDirectionField)
        addressFieldContainer.addSubview(addressDividerView)

        addressFieldContainer.addSubview(addressAdditionalInformationContainer)
        addressAdditionalInformationContainer.addSubview(additionalInformationLabel)
        addressAdditionalInformationContainer.addSubview(fillWithDefaultInformations)

        addressAdditionalInformationContainer.addSubview(additionalInfoContactNameTF)
        addressAdditionalInformationContainer.addSubview(additionalInfoContactSurnameTF)
        addressAdditionalInformationContainer.addSubview(additionalInfoContactPhoneNoTF)

        NSLayoutConstraint.deactivate(mapView.constraints)
        NSLayoutConstraint.deactivate(continueWithAddressButtonView.constraints)

        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.3),

            continueWithAddressButtonView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            continueWithAddressButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            continueWithAddressButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            continueWithAddressButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            addressFieldContainer.topAnchor.constraint(equalTo: continueWithAddressButtonView.topAnchor, constant: 10),
            addressFieldContainer.leadingAnchor.constraint(equalTo: continueWithAddressButtonView.leadingAnchor, constant: 20),
            addressFieldContainer.trailingAnchor.constraint(equalTo: continueWithAddressButtonView.trailingAnchor, constant: -20),
            addressFieldContainer.bottomAnchor.constraint(equalTo: buttonUIView.topAnchor, constant: -20),

            addressCityField.topAnchor.constraint(equalTo: addressFieldContainer.topAnchor),
            addressCityField.leadingAnchor.constraint(equalTo: addressFieldContainer.leadingAnchor),
            addressCityField.widthAnchor.constraint(equalTo: addressFieldContainer.widthAnchor, multiplier: 1/2.05),
            addressCityField.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            addressDistrictField.topAnchor.constraint(equalTo: addressCityField.topAnchor),
            addressDistrictField.trailingAnchor.constraint(equalTo: addressFieldContainer.trailingAnchor),
            addressDistrictField.widthAnchor.constraint(equalTo: addressFieldContainer.widthAnchor, multiplier: 1/2.05),
            addressDistrictField.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            addressStreetField.topAnchor.constraint(equalTo: addressCityField.bottomAnchor, constant: 10),
            addressStreetField.leadingAnchor.constraint(equalTo: addressFieldContainer.leadingAnchor),
            addressStreetField.trailingAnchor.constraint(equalTo: addressFieldContainer.trailingAnchor),
            addressStreetField.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            addressFieldsStackView.topAnchor.constraint(equalTo: addressStreetField.bottomAnchor, constant: 10),
            addressFieldsStackView.leadingAnchor.constraint(equalTo: addressFieldContainer.leadingAnchor),
            addressFieldsStackView.trailingAnchor.constraint(equalTo: addressFieldContainer.trailingAnchor),
            addressFieldsStackView.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            addressDirectionField.topAnchor.constraint(equalTo: addressFieldsStackView.bottomAnchor, constant: 10),
            addressDirectionField.leadingAnchor.constraint(equalTo: addressFieldContainer.leadingAnchor),
            addressDirectionField.trailingAnchor.constraint(equalTo: addressFieldContainer.trailingAnchor),
            addressDirectionField.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            addressDividerView.topAnchor.constraint(equalTo: addressDirectionField.bottomAnchor, constant: 15),
            addressDividerView.leadingAnchor.constraint(equalTo: addressDirectionField.leadingAnchor),
            addressDividerView.trailingAnchor.constraint(equalTo: addressDirectionField.trailingAnchor),
            addressDividerView.heightAnchor.constraint(equalToConstant: 1),

            addressAdditionalInformationContainer.topAnchor.constraint(equalTo: addressDividerView.bottomAnchor, constant: 15),
            addressAdditionalInformationContainer.leadingAnchor.constraint(equalTo: addressDirectionField.leadingAnchor),
            addressAdditionalInformationContainer.trailingAnchor.constraint(equalTo: addressDirectionField.trailingAnchor),
            addressAdditionalInformationContainer.bottomAnchor.constraint(equalTo: buttonUIView.topAnchor, constant: -20),

            additionalInformationLabel.topAnchor.constraint(equalTo: addressAdditionalInformationContainer.topAnchor),
            additionalInformationLabel.leadingAnchor.constraint(equalTo: addressAdditionalInformationContainer.leadingAnchor),
            additionalInformationLabel.heightAnchor.constraint(equalToConstant: 20),

            fillWithDefaultInformations.topAnchor.constraint(equalTo: additionalInformationLabel.topAnchor),
            fillWithDefaultInformations.leadingAnchor.constraint(equalTo: additionalInformationLabel.trailingAnchor, constant: 10),
            fillWithDefaultInformations.widthAnchor.constraint(equalToConstant: 150),
            fillWithDefaultInformations.bottomAnchor.constraint(equalTo: additionalInformationLabel.bottomAnchor),

            additionalInfoContactNameTF.topAnchor.constraint(equalTo: additionalInformationLabel.bottomAnchor, constant: 10),
            additionalInfoContactNameTF.leadingAnchor.constraint(equalTo: addressAdditionalInformationContainer.leadingAnchor),
            additionalInfoContactNameTF.widthAnchor.constraint(equalToConstant: 150),
            additionalInfoContactNameTF.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            additionalInfoContactSurnameTF.topAnchor.constraint(equalTo: additionalInfoContactNameTF.topAnchor),
            additionalInfoContactSurnameTF.leadingAnchor.constraint(equalTo: additionalInfoContactNameTF.trailingAnchor, constant: 10),
            additionalInfoContactSurnameTF.widthAnchor.constraint(equalToConstant: 150),
            additionalInfoContactSurnameTF.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            additionalInfoContactPhoneNoTF.topAnchor.constraint(equalTo: additionalInfoContactSurnameTF.bottomAnchor, constant: 10),
            additionalInfoContactPhoneNoTF.leadingAnchor.constraint(equalTo: addressAdditionalInformationContainer.leadingAnchor),
            additionalInfoContactPhoneNoTF.trailingAnchor.constraint(equalTo: addressAdditionalInformationContainer.trailingAnchor),
            additionalInfoContactPhoneNoTF.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            buttonUIView.leadingAnchor.constraint(equalTo: continueWithAddressButtonView.leadingAnchor, constant: 20),
            buttonUIView.trailingAnchor.constraint(equalTo: continueWithAddressButtonView.trailingAnchor, constant: -20),
            buttonUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buttonUIView.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),

            sendCurrentAddressDataLabel.centerXAnchor.constraint(equalTo: buttonUIView.centerXAnchor),
            sendCurrentAddressDataLabel.centerYAnchor.constraint(equalTo: buttonUIView.centerYAnchor)
        ])

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
            Task {
                @MainActor in
                self?.searchContainerView.isHidden = true
                self?.sendCurrentAddressDataLabel.text = "Adresi Kaydet"
                if self?.selectedAddress != nil {
                    self?.addressCityField.text = self?.selectedAddress?.userCity
                    self?.addressDistrictField.text =  self?.selectedAddress?.userDistrict
                    self?.addressStreetField.text =  self?.selectedAddress?.userStreet
                    self?.addressStructureNoField.text =  self?.selectedAddress?.userStructureNo
                    self?.postalCode = self?.selectedAddress?.userPostCode

                }
            }
        }
    }

    @objc private func getAuthUserInformations(){
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists, let data = document.data() else {
                print("Document does not exist or an error occurred")
                return
            }

            let firstName = data["firstName"] as? String ?? ""
            let lastName = data["lastName"] as? String ?? ""
            let phoneNumber = data["phoneNumber"] as? String ?? ""
            Task {
                @MainActor in
                self.additionalInfoContactNameTF.text = firstName
                self.additionalInfoContactSurnameTF.text = lastName
                self.additionalInfoContactPhoneNoTF.text = phoneNumber
            }
        }
    }

    private func saveAddressToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturum açmamış")
            return
        }

        let addressId = UUID().uuidString
        let addressData: [String: Any] = [
            "id": addressId,  // ID'yi ekleyin
            "city": addressCityField.text ?? "",
            "district": addressDistrictField.text ?? "",
            "street": addressStreetField.text ?? "",
            "structureNo": addressStructureNoField.text ?? "",
            "floorNumber": addressFloorNumberField.text ?? "",
            "apartmentNumber": addressApartmentNumberField.text ?? "",
            "addressDirection": addressDirectionField.text ?? "",
            "contactName": additionalInfoContactNameTF.text ?? "",
            "contactSurname": additionalInfoContactSurnameTF.text ?? "",
            "contactPhoneNumber": additionalInfoContactPhoneNoTF.text ?? "",
            "postalCode": postalCode ?? "",
            "timestamp": FieldValue.serverTimestamp()
        ]

        let db = Firestore.firestore()
        let addressRef = db.collection("users").document(userId).collection("addresses").document(addressId)

        addressRef.setData(addressData) { error in
            if let error = error {
                print("Adres kaydedilirken hata oluştu: \(error.localizedDescription)")
            } else {
                print("Adres başarıyla kaydedildi")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func userDidSelectMapView() {
        print("map touched")
        if searchContainerView.isHidden != true 
        {
            resultsTableView.isHidden = true
            return
        }

        NSLayoutConstraint.deactivate(mapView.constraints)
        NSLayoutConstraint.deactivate(
            continueWithAddressButtonView.constraints.filter
            { $0.firstAttribute == .top || $0.firstAttribute == .bottom }
        )

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            self.addressFieldContainer.isHidden = true
        }

        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            continueWithAddressButtonView.heightAnchor.constraint(equalToConstant: 120),
            continueWithAddressButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            buttonUIView.leadingAnchor.constraint(equalTo: continueWithAddressButtonView.leadingAnchor, constant: 20),
            buttonUIView.trailingAnchor.constraint(equalTo: continueWithAddressButtonView.trailingAnchor, constant: -20),
            buttonUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buttonUIView.heightAnchor.constraint(equalToConstant: view.bounds.height * Constants.multiplication),
        ])

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.postalCode = self?.selectedAddress?.userPostCode
            Task {
                @MainActor in
                self?.sendCurrentAddressDataLabel.isEnabled = true
                self?.searchContainerView.isHidden = false
                self?.sendCurrentAddressDataLabel.text = "Devam Et"
            }
        }
    }
}


extension AddressMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        mapViewManager?.selectLocation(with: selectedResult) { [weak self] address in
            guard let self = self else { return }
            selectedAddress = address

            if selectedAddress != nil {
                addressCityField.text = selectedAddress?.userCity
                addressDistrictField.text = selectedAddress?.userDistrict
                addressStreetField.text = selectedAddress?.userStreet
                addressStructureNoField.text = selectedAddress?.userStructureNo
            }

            self.resultsTableView.isHidden = true
            self.searchTextField.resignFirstResponder()
        }
    }
}

extension AddressMapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .white
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.textLabel?.textColor = .black
        return cell
    }
}

extension AddressMapViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        if newString.isEmpty {
            resultsTableView.isHidden = true
        } else {
            resultsTableView.isHidden = false
            searchCompleter?.queryFragment = newString
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddressMapViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        resultsTableView.isHidden = searchResults.isEmpty
        resultsTableView.reloadData()
    }
}

extension AddressMapViewController {
    enum Constants{
        static let textFieldHeight: CGFloat = 52
        static let multiplication: CGFloat = 0.0675
    }
}
