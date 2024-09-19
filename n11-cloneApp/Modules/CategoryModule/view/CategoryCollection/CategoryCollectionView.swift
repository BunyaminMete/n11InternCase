//
//  DenemeView.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 5.08.2024.
//

import UIKit

protocol CategoryCollectionViewDelegate: AnyObject {
    func categoryCollectionViewDidSelectItem()
}

class CategoryCollectionView: UIView {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    weak var delegate: CategoryCollectionViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kategoriler"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupTitleLabel()
        configureDataSource()
        applyInitialSnapshot()
    }

    private func setupCollectionView() {
        let layout = CompositionalLayoutManagerCV.sharedInstance.createLayoutSection()
        categoryCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: layout)

        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollectionView.register(nib, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        categoryCollectionView.delegate = self
        categoryCollectionView.isScrollEnabled = false
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: categoryCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            cell.setupCategoryLabel(categoryText: mockCateogryTitles[indexPath.row], categoryImageURL: mockCategories[indexPath.row])
            return cell
        }
    }

    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])

        let items = (1..<mockCategories.count).map { "Item \($0)" }
        snapshot.appendItems(items, toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CategoryCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
//            print("Clicked to item \(cell.categoryLabel)")
//        }
//
//        if let categoryMainCellIdentifier = dataSource.itemIdentifier(for: indexPath) {
//            delegate?.categoryCollectionViewDidSelectItem()
//        }
    }
}
