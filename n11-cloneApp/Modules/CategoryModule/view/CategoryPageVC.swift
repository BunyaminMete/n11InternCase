//
//  CategoryPageVC.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 5.08.2024.
//

import UIKit

protocol CategoryPageViewProtocol: AnyObject {
    func displayCategories(_ categories: [String])
}

class CategoryPageVC: UIViewController, CategoryPageViewProtocol, CategoryCollectionViewDelegate {
    func displayCategories(_ categories: [String]) {
        print(categories)
    }

    private let returnBackButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let arrowImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()

    var presenter: CategoryPagePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        returnBackButton.isHidden = false
        self.view.backgroundColor = UIColor(named: "purple11")
        configureCustomNavigationBar()
        setupCategoryCollectionView()
    }

    private func configureCustomNavigationBar() {
        let customNavBar = CustomNavigationBar2()
        returnBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)


        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addSubview(customNavBar)
            navigationBar.addSubview(returnBackButton)

            customNavBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                returnBackButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 10),
                returnBackButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor, constant: 10),
                returnBackButton.heightAnchor.constraint(equalToConstant: 18),
                returnBackButton.widthAnchor.constraint(equalToConstant: 18),

                customNavBar.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 20),
                customNavBar.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -20),
                customNavBar.heightAnchor.constraint(equalToConstant: 80)
            ])
        }

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = UIColor(named: "purple11")
        navigationItem.backBarButtonItem = backButton
    }

    private func setupCategoryCollectionView() {
        let nib = UINib(nibName: "CategoryCollectionView", bundle: nil)
        guard let categoryCollectionView = nib.instantiate(withOwner: self, options: nil).first as? CategoryCollectionView else { return }

        categoryCollectionView.delegate = self
        view.addSubview(categoryCollectionView)

        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func categoryCollectionViewDidSelectItem() {
        print("Presenter")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
