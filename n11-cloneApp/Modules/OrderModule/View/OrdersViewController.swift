//
//  OrdersViewController.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 12.09.2024.
//


import UIKit
import FirebaseAuth


enum OrderHistorySection {
    case main
}

class OrderHistoryViewController: UIViewController, UIGestureRecognizerDelegate {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<OrderHistorySection, OrdersHistoryPresentationModel>!
    private var networkHistory = FirestoreNetworking()

    private var orders: [[OrdersHistoryPresentationModel]] = []
    private var bubbleImages: [String] = []
    private var totalAmountSpendForEachOrder: Double = 0
    private var storeData: Date = Date()
    private var ordersModified: [OrdersHistoryPresentationModel] = []
    var presenter: OrderPresenterProtocol?

    private let customNavBar: OtherNavigationBar = {
        let navBar = OtherNavigationBar()
        navBar.configure(withTitle: "Siparişlerim")
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
        presenter?.fetchOrders()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    private func configureNavigationBar() {
        let backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .clear

        let chevronImage = UIImage(systemName: "chevron.left")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))

        let backButton = UIButton()
        backButton.setImage(chevronImage, for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)

        view.addSubview(customNavBar)
        customNavBar.addSubview(backView)
        backView.addSubview(backButton)

        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 120),

            backView.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 20),
            backView.widthAnchor.constraint(equalToConstant: 40),
            backView.heightAnchor.constraint(equalToConstant: 40),
            backView.bottomAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: -10),

            backButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            backButton.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            backButton.widthAnchor.constraint(equalTo: backView.widthAnchor),
            backButton.heightAnchor.constraint(equalTo: backView.heightAnchor)
        ])
    }

    @objc private func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: OrderHistoryLayout.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .babyblue11

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.delegate = self
        collectionView.register(OrderHistoryCell.self, forCellWithReuseIdentifier: OrderHistoryCell.reuseIdentifier)
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<
            OrderHistoryCell, OrdersHistoryPresentationModel> { cell, indexPath, model in
                cell.bind(model)
        }

        dataSource = UICollectionViewDiffableDataSource<OrderHistorySection, OrdersHistoryPresentationModel>(
            collectionView: collectionView
        ) { collectionView, indexPath, model in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: model
            )
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<OrderHistorySection, OrdersHistoryPresentationModel>()
        snapshot.appendSections([.main])
        let sortedOrders = ordersModified.sorted {
            $0.productsOrderDate < $1.productsOrderDate
        }
        snapshot.appendItems(sortedOrders, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func fetchOrders() {
        presenter?.fetchOrders()
    }

    func updateOrders(_ orders: [OrdersHistoryPresentationModel]) {
        self.ordersModified = orders
        applySnapshot()
    }
}

extension OrderHistoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped \(indexPath.item)")
        print(orders)
    }
}

extension OrderHistoryViewController: OrderViewProtocol {
    func displayOrders(_ orders: [OrdersHistoryPresentationModel]) {
        updateOrders(orders)
    }
}
