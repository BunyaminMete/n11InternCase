//
//  CompositionalLayoutManagerCV.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 5.08.2024.
//

import UIKit

class CompositionalLayoutManagerCV {
    
    static let sharedInstance = CompositionalLayoutManagerCV()
    
    func createLayoutSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(125))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(125))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item, item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }
    
    
}
