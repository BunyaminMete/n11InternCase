//
//  AddressViewController.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.09.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddressViewController: UIViewController, UIGestureRecognizerDelegate {

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<
        Int, AddressModel
    >!
    var totalHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Adreslerim"

        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "purple11")
            navigationBar.standardAppearance    = appearance
            navigationBar.scrollEdgeAppearance  = appearance

            navigationItem.standardAppearance   = appearance
            navigationItem.scrollEdgeAppearance = appearance
        }

        setupCollectionView()   // Collection view yapılandırması
        configureDataSource()   // Diffable data source yapılandırması
        setupBottomButton()     // Alt buton yapılandırması
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden    = false
        self.tabBarController?.tabBar.isHidden              = true
        fetchAndUpdateAddresses()  // Verileri çek ve güncelle

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden    = true
        createFakeNavigationComponent(color: .purple11, height: totalHeight, view: view)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaInsets = view.safeAreaInsets
        totalHeight = safeAreaInsets.top
    }

    private func setupFakeNavigationBar(){
        let fakeUIView = UIView()
        fakeUIView.translatesAutoresizingMaskIntoConstraints = false
        fakeUIView.backgroundColor = .purple11

        view.addSubview(fakeUIView)
        if let superview = view.superview {
            NSLayoutConstraint.activate([
                fakeUIView.topAnchor.constraint(equalTo: superview.topAnchor),
                fakeUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                fakeUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                fakeUIView.heightAnchor.constraint(equalToConstant: totalHeight)
            ])
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            section.interGroupSpacing = 10

            return section
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "#F5F5F5")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AddressCell.self, forCellWithReuseIdentifier: AddressCell.reuseIdentifier)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint         (equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint     (equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint    (equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint      (equalTo: view.bottomAnchor, constant: -100)
        ])
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, AddressModel
        >(collectionView: collectionView) { (collectionView, indexPath, address) -> UICollectionViewCell? in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCell.reuseIdentifier, for: indexPath) as? AddressCell else {
                return UICollectionViewCell()
            }

            cell.configure(with: address)
            cell.delegate = self
            return cell
        }
    }

    private func fetchAndUpdateAddresses() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("addresses").getDocuments { [weak self] (snapshot, error) in
            guard let self = self, let documents = snapshot?.documents, error == nil else {
                print("Error fetching addresses: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var addressModels: [AddressModel] = []

            for document in documents {
                let data = document.data()
                let documentId = document.documentID
                let city = data["city"] as? String ?? ""
                let district = data["district"] as? String ?? ""
                let street = data["street"] as? String ?? ""
                let structureNo = data["structureNo"] as? String ?? ""
                let floorNumber = data["floorNumber"] as? String ?? ""
                let postalCode = data["postalCode"] as? String ?? ""
                let apartmentNumber = data["apartmentNumber"] as? String ?? ""
                let contactName = data["contactName"] as? String ?? ""
                let contactSurname = data["contactSurname"] as? String ?? ""
                let addressDirection = data["addressDirection"] as? String ?? ""
                let addressTitle = "\(contactName) \(contactSurname)"

                let addressFull = "\(city), \(district), \(street), No: \(structureNo), Kat: \(floorNumber), Daire: \(apartmentNumber), Adres Tarifi: \(addressDirection), Posta Kodu: \(postalCode)"

                let addressModel = AddressModel(id: documentId,
                                                addressTitle: addressTitle,
                                                addressFull: addressFull)
                addressModels.append(addressModel)
            }

            let addressMapVC = AddressMapViewController()

            if addressModels.isEmpty {
                navigationController?.pushViewController(addressMapVC, animated: true)
            }

            self.updateDataSource(with: addressModels)
        }
    }

    private func updateDataSource(with addressModels: [AddressModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AddressModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(addressModels)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupBottomButton() {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)

        let button = UIButton()
        button.setTitle("Yeni Adres Ekle", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(named: "purple11")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(redirectToAddressMapKit), for: .touchUpInside)
        bottomView.addSubview(button)

        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint (equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint  (equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint  (equalToConstant: 100),

            button.leadingAnchor.constraint     (equalTo: bottomView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint    (equalTo: bottomView.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint     (equalTo: bottomView.centerYAnchor, constant: -10),
            button.heightAnchor.constraint      (equalToConstant: 50)
        ])
    }

    @objc private func redirectToAddressMapKit() {
        let addressMapVC = AddressMapViewController()
        navigationController?.pushViewController(addressMapVC, animated: true)
        print("Redirecting to AddressMapViewController")
    }
}

extension AddressViewController: AddressCellDelegate {
    func didTapTrashButton(in cell: AddressCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let address = dataSource.itemIdentifier(for: indexPath)
        guard let addressId = address?.id else { return }

        deleteAddress(withId: addressId)
    }

    private func deleteAddress(withId addressId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User ID not found")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("addresses").whereField("id", isEqualTo: addressId).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching address for deletion: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No documents found for ID: \(addressId)")
                return
            }

            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting address: \(error.localizedDescription)")
                    } else {
                        print("Address successfully deleted")
                        // Optionally, update the UI
                        DispatchQueue.main.async {
                            self.fetchAndUpdateAddresses()
                        }
                    }
                }
            }
        }
    }
}
