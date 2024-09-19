//
//  FavouritesViewController.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 8.08.2024.
//

import UIKit
import FirebaseAuth

class FavouritesViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<
        FavouriteSection, SavedProductCardPresentationModel
    >!

    var presenter: FavouritesPresenterProtocol?

    private let statusMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let statusMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.purple11
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private let customNavBar: OtherNavigationBar = {
        let navBar = OtherNavigationBar()
        navBar.configure(withTitle: "Favorilerim")
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFavouriteNavigationBar()
        configureCollectionView()
        configureDataSource()
        statusConfigure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchFavouriteProducts()
    }


    private func statusConfigure() {
        view.addSubview(statusMessageView)
        statusMessageView.addSubview(statusMessageLabel)

        NSLayoutConstraint.activate([
            statusMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusMessageView.heightAnchor.constraint(equalToConstant: 40),
            statusMessageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),

            statusMessageLabel.centerYAnchor.constraint(equalTo: statusMessageView.centerYAnchor),
            statusMessageLabel.leadingAnchor.constraint(equalTo: statusMessageView.leadingAnchor, constant: 10),
            statusMessageLabel.trailingAnchor.constraint(equalTo: statusMessageView.trailingAnchor, constant: -10)
        ])
        statusMessageView.isHidden = true
    }

    func showStatusMessage(_ message: String) {
        statusMessageLabel.text = message
        statusMessageView.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.statusMessageView.isHidden = true
        }
    }

    private func configureFavouriteNavigationBar() {
        view.addSubview(customNavBar)

        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(hex: "#F2F2F2")

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.delegate = self
        collectionView.register(FavouritesCell.self, forCellWithReuseIdentifier: FavouritesCell.reuseIdentifier)
    }

    private func createLayout() -> UICollectionViewLayout {
           return createCompositionalLayout()
       }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<
            FavouritesCell, SavedProductCardPresentationModel
        > { [weak self] cell, indexPath, model in
            cell.bind(model)

            cell.onDeleteButtonTapped = {
                self?.presenter?.removeProductFromFavourites(model.productTitle)
            }

            cell.onAddToBasketButtonTapped = {
                self?.presenter?.addProductToBasket(model)
            }
        }

        dataSource = UICollectionViewDiffableDataSource<FavouriteSection,
                                                        SavedProductCardPresentationModel>(collectionView: collectionView) {
            collectionView, indexPath, model in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
    }

    func displayFavouriteProducts(_ products: [SavedProductCardPresentationModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<
            FavouriteSection, SavedProductCardPresentationModel
        >()

        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension FavouritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItemModel = dataSource.itemIdentifier(for: indexPath)
        let detailVC = ProductDetailViewController()
        detailVC.product = HomeModuleProductCardPresentationModel(
            productImages: selectedItemModel?.productImages ?? [],
            productTitle: selectedItemModel?.productTitle ?? "",
            productRate: selectedItemModel?.productRate ?? false,
            productPrice: selectedItemModel?.productPrice ?? 0,
            freeShipment: selectedItemModel?.freeShipment ?? false
        )

        present(detailVC, animated: true)
    }
}

extension FavouritesViewController: FavouritesViewProtocol {
    func callShowStatusMessage(_ message: String) {
        self.showStatusMessage(message)
    }

    func callDisplayFavouriteProducts(_ products: [SavedProductCardPresentationModel]) {
        self.displayFavouriteProducts(products)
    }
    
    func isFavouriteListChanged () {
        presenter?.fetchFavouriteProducts()
    }
}
