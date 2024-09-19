//
//  FavouritesLayoutManager.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 10.09.2024.
//

import UIKit

enum FavouriteSection: Int, Hashable, CaseIterable {
    case main
}

func createCompositionalLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
        guard let section = FavouriteSection(rawValue: sectionIndex) else {
            return nil
        }

        switch section {
        case .main:
            return createMainSectionLayout()
        }
    }
    return layout
}

private func createMainSectionLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(170))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(170))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .none 
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0)
    return section
}
