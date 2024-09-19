//
//  BasketViewController.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.08.2024.

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BasketViewController: UIViewController, BasketProductContainerCellDelegate {
    private let customNavigationBar = OtherNavigationBar()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, SavedProductCardPresentationModel>!
    private let firestoreNetworking = FirestoreNetworking()
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    private let emptyStateStackView = UIStackView()
    var presenter: BasketPresenter!

    var backButton: UIButton = UIButton()

    private var storedProduct: [SavedProductCardPresentationModel] = [SavedProductCardPresentationModel(
        productImages: [""],
        productTitle: "",
        productRate: true,
        productPrice: 0,
        freeShipment: true,
        amount: 0,
        creationDate: Date(),
        documentId: "",
        isFavourite: false)]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customNavigationBar)
        view.backgroundColor = .babyblue11

        customNavigationBar.configure(withTitle: "Sepetim")
        customNavigationBar.deleteProductsButton.addTarget(self, action: #selector(deleteBasketItems) , for: .touchUpInside)
        setupNavigationBarConstraints()
        configureCollectionView()
        configureDataSource()
        configureBackButton()
        configureEmptyStateView()
        configureBottomTotalBasket(totalNumber: 0)
        collectionView.delegate = self
        view.isUserInteractionEnabled = true

        let fakeRequestForPaymentGesture = UITapGestureRecognizer(target: self, action: #selector(fakeOrderRequest))
        bottomViewRightContainer.addGestureRecognizer(fakeRequestForPaymentGesture)

        if tabBarController?.selectedIndex == 2
        {
            navigationController?.isNavigationBarHidden = true
        }
        else
        {
            navigationController?.isNavigationBarHidden = false
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchBasketItems()
        collectionView.reloadData()
        if tabBarController?.selectedIndex == 2
        {
            navigationController?.isNavigationBarHidden = true
        }
        else
        {
            navigationController?.isNavigationBarHidden = false
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            (navigationController?.delegate as? CustomNavigationControllerDelegate)?.isBasket = false
        }
    }

    func didUpdateQuantity(for documentId: String) {
        fetchBasketItems()
    }

    private func configureBackButton() {
        let chevronImage = UIImage(systemName: "chevron.left")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .bold))

        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = chevronImage
        buttonConfiguration.baseBackgroundColor = .clear
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.imagePlacement = .leading

        backButton = UIButton(configuration: buttonConfiguration)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            containerView.widthAnchor.constraint(equalToConstant: 40),
            containerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        let barButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = barButtonItem
        if navigationController?.isNavigationBarHidden == true {
            customNavigationBar.deleteProductsButton.isHidden = true
        } else {
            customNavigationBar.deleteProductsButton.isHidden = false
        }
    }

    @objc private func handleBackButtonTapped() {
        print("Back button tapped")
        navigationController?.popViewController(animated: true)
    }

    private func setupNavigationBarConstraints() {
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

            return section
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .babyblue11

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BasketProductContainerCell.self,
                                forCellWithReuseIdentifier: BasketProductContainerCell.reuseIdentifier)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -143)
        ])
    }

    let bottomViewRightContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple11
        view.layer.cornerRadius = 6
        view.isUserInteractionEnabled = true
        return view
    }()

    let rightLabelBottomPaymentButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.text = "Ödemeye Geç"

        return label
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let bottomViewLeftContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let leftLabelTop: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .darkGray

        return label
    }()

    let leftLabelBottomPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black

        return label
    }()

    private func configureBottomTotalBasket(totalNumber: Double) {

        if totalNumber == 0 {
            bottomView.isHidden = true
        } else {
            bottomView.isHidden = false
        }
        leftLabelBottomPrice.alpha = 0.4
        leftLabelTop.alpha = 0.4

        presenter.requestTotalPriceAndProductCount()

        bottomView.removeFromSuperview()

        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        bottomView.addSubview(bottomViewLeftContainer)
        bottomViewLeftContainer.addSubview(leftLabelTop)
        bottomViewLeftContainer.addSubview(leftLabelBottomPrice)

        bottomView.addSubview(bottomViewRightContainer)
        bottomViewRightContainer.addSubview(rightLabelBottomPaymentButton)

        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 60),

            bottomViewLeftContainer.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5),
            bottomViewLeftContainer.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor,constant: 5),
            bottomViewLeftContainer.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 1/2.5),
            bottomViewLeftContainer.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -5),

            leftLabelTop.topAnchor.constraint(equalTo: bottomViewLeftContainer.topAnchor, constant: 2),
            leftLabelTop.leadingAnchor.constraint(equalTo: bottomViewLeftContainer.leadingAnchor, constant: 5),

            leftLabelBottomPrice.topAnchor.constraint(equalTo: leftLabelTop.topAnchor, constant: 10),
            leftLabelBottomPrice.leadingAnchor.constraint(equalTo: leftLabelTop.leadingAnchor, constant: 0),
            leftLabelBottomPrice.bottomAnchor.constraint(equalTo: bottomViewLeftContainer.bottomAnchor, constant: 0),

            bottomViewRightContainer.topAnchor.constraint(equalTo: bottomViewLeftContainer.topAnchor),
            bottomViewRightContainer.leadingAnchor.constraint(equalTo: bottomViewLeftContainer.trailingAnchor, constant: 15),
            bottomViewRightContainer.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -5),
            bottomViewRightContainer.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -5),

            rightLabelBottomPaymentButton.centerXAnchor.constraint(equalTo: bottomViewRightContainer.centerXAnchor),
            rightLabelBottomPaymentButton.centerYAnchor.constraint(equalTo: bottomViewRightContainer.centerYAnchor),
        ])
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, SavedProductCardPresentationModel>(
            collectionView: collectionView
        ) { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BasketProductContainerCell.reuseIdentifier,
                for: indexPath
            ) as? BasketProductContainerCell else {
                return nil
            }

            cell.delegate = self
            if let imageName = item.productImages.first {
                downloadImage(with: imageName) { image in
                    cell.configure(with: item.productTitle,
                                   image: image,
                                   productPrice: item.productPrice,
                                   amount: item.amount,
                                   documentId: item.documentId)
                }
            }
            return cell
        }
    }

    private func fetchBasketItems() {
        presenter.getUserBasketList()
    }

    @objc private func deleteBasketItems() {
        presenter.requestToDeleteBasketItems()
    }

    @objc private func fakeOrderRequest(){
        presenter.userWantsToOrder()
    }

    private func applySnapshot(with products: [SavedProductCardPresentationModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SavedProductCardPresentationModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(products, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureEmptyStateView() {
        print("empty show")
        emptyStateImageView.image = UIImage(named: "empty_basket")
        emptyStateImageView.contentMode = .scaleAspectFit

        emptyStateLabel.text = "Sepetin Boş Görünüyor"
        emptyStateLabel.textColor = .gray
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emptyStateLabel.textAlignment = .center

        emptyStateStackView.axis = .vertical
        emptyStateStackView.alignment = .center
        emptyStateStackView.spacing = 10
        emptyStateStackView.translatesAutoresizingMaskIntoConstraints = false

        emptyStateStackView.addArrangedSubview(emptyStateImageView)
        emptyStateStackView.addArrangedSubview(emptyStateLabel)

        view.addSubview(emptyStateStackView)

        NSLayoutConstraint.activate([
            emptyStateStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 150),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 150)
        ])

        emptyStateStackView.isHidden = true
    }

    @objc private func dismissPresentation(){
        self.dismiss(animated: true)
    }
}

extension BasketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item tapped at index: \(indexPath.item)")
        let selectedItemWithModel = storedProduct[indexPath.item]

        let pdpModule = PDPBuilder.createModule()
        if let pdpVC = pdpModule as? ProductDetailViewController{
            pdpVC.product = HomeModuleProductCardPresentationModel(productImages:selectedItemWithModel.productImages,
                                                                   productTitle: selectedItemWithModel.productTitle,
                                                                   productRate: selectedItemWithModel.productRate,
                                                                   productPrice: selectedItemWithModel.productPrice / Double(selectedItemWithModel.amount),
                                                                   freeShipment: selectedItemWithModel.freeShipment)
            
            if !isMovingFromParent {
                pdpVC.backToRootButton.addTarget(self, action: #selector(dismissPresentation), for: .touchUpInside)
                present(pdpVC, animated: true)
            }
        }
    }

}

extension BasketViewController: BasketViewProtocol{
    func fetchUserBasketListAndUpdate(with product: [SavedProductCardPresentationModel]) {
        storedProduct = product
        self.applySnapshot(with: product)
        self.emptyStateStackView.isHidden = !product.isEmpty

        if !product.isEmpty {
            self.configureBottomTotalBasket(totalNumber: 1)
        } else {
            self.configureBottomTotalBasket(totalNumber: 0)
        }
    }

    func updateEmptyBasketViewController() {
        fetchBasketItems()
    }

    func updateTotalPrice(_ totalPrice: String) {
        UIView.animate(withDuration: 0.1) {
            self.leftLabelBottomPrice.text = totalPrice
            self.leftLabelBottomPrice.alpha = 1
        }
    }

    func updateTotalProductCount(_ totalProductCountText: String) {
        UIView.animate(withDuration: 0.1) {
            self.leftLabelTop.text = totalProductCountText
            self.leftLabelTop.alpha = 1
        }
    }
}
