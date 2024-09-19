//
//  CompositionalLayoutManager.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 3.08.2024.
//

import UIKit

final class HomeModuleCollectionLayoutMaker {
    private init() {}
    
    static let sharedInstance = HomeModuleCollectionLayoutMaker()
    
    static var conceptLayoutProductSectionDidCreate = 0
    static var conceptLayoutBottomSectionDidCreate = 0
    
    func layoutSection(for cellType: CellType) -> NSCollectionLayoutSection {
        switch cellType {
        case .shortcutBoxSectionCell:
            return createShortcutSection(isSlider: false)
        case .autoCarouselSectionCell:
            return createAutoCarouselSection()
        case .manuelCarouselSectionCell:
            return createManuelCarouselSection()
        case .productCardSectionCell:
            return createProductSliderSection(productHeader: HomeModuleProductCardHeaderReusableView.headerIdentifier)
        case .conceptContainerUpperSectionCell:
            return createProductSliderSection(productHeader: HomeModuleConceptImageHeaderReusableView.headerIdentifier)
        case .conceptContainerBottomSectionCell:
            return createConceptBottomBrandSection()
        default:
            print("Warning: Unhandled cell type. Returning default layout.")
            return HomeModuleCollectionLayoutMaker.sharedInstance.createProductSliderSection(productHeader: "")
        }
    }
    
    
}

// MARK: -- Shortcuts Section Layout

extension HomeModuleCollectionLayoutMaker {
    private func createShortcutSection(isSlider: Bool) -> NSCollectionLayoutSection {
        if isSlider {
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            section.orthogonalScrollingBehavior = .continuous
            section.decorationItems = [
                NSCollectionLayoutDecorationItem.background(elementKind: "shortcutBackground")
            ]
            
            return section
        } else {
            let largeItemSize = NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(120))
            let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
            largeItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 5)
            
            let smallItemSize = NSCollectionLayoutSize(widthDimension: .absolute(105), heightDimension: .absolute(120))
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom:  15, trailing: 8)
            
            let largeGroup = NSCollectionLayoutGroup.horizontal(layoutSize: largeItemSize, subitems: [largeItem])
            
            let smallGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(600), heightDimension: .absolute(120))
            let smallGroup = NSCollectionLayoutGroup.horizontal(layoutSize: smallGroupSize, subitems: [smallItem, smallItem, smallItem, smallItem, smallItem, smallItem, smallItem])
            
            let sectionGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(1200), heightDimension: .absolute(120))
            let sectionGroup = NSCollectionLayoutGroup.horizontal(layoutSize: sectionGroupSize, subitems: [largeGroup, smallGroup])
            
            let section = NSCollectionLayoutSection(group: sectionGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: -5, leading: 0, bottom: -10, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
            section.decorationItems = [
                NSCollectionLayoutDecorationItem.background(elementKind: "shortcutBackground")
            ]
            
            return section
        }
    }
}


// MARK: -- Auto Carousel Section

extension HomeModuleCollectionLayoutMaker {
    private func createAutoCarouselSection() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(175))
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
}

// MARK: -- Manuel Carousel Section

extension HomeModuleCollectionLayoutMaker {
    private func createManuelCarouselSection() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(100))
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 15, trailing: 20)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
}

// MARK: -- Product Slider Section Optional Header Section

var elementKinds = ["conceptBackgroundEx1",
                    "conceptBackgroundEx2",
                    "conceptBackgroundEx3",
                    "conceptBackgroundEx4",
                    "conceptBackgroundEx5"]

extension HomeModuleCollectionLayoutMaker {
    private func createProductSliderSection(productHeader: String?) -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.36), heightDimension: .absolute(280))
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0)

        if let productHeader = productHeader, productHeader == "HomeModuleProductCardHeaderReusableView" {
            HomeModuleCollectionLayoutMaker.conceptLayoutBottomSectionDidCreate = 0
            HomeModuleCollectionLayoutMaker.conceptLayoutProductSectionDidCreate = 0
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.075))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            section.boundarySupplementaryItems = [headerItem]
            section.orthogonalScrollingBehavior = .continuous
            section.decorationItems = [
                NSCollectionLayoutDecorationItem.background(elementKind: "productCounterBackground")
            ]
        }
        else if productHeader == "HomeModuleConceptImageHeaderReusableView" {
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.55))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [headerItem]
            section.orthogonalScrollingBehavior = .continuous
            
            
            let productSectionReferance = HomeModuleCollectionLayoutMaker.conceptLayoutProductSectionDidCreate
            HomeModuleCollectionLayoutMaker.conceptLayoutProductSectionDidCreate += 1
            
            if productSectionReferance < elementKinds.count {
                section.decorationItems = [
                    NSCollectionLayoutDecorationItem.background(elementKind: elementKinds[productSectionReferance])
                ]
            }
        }
        
        else {
            section.orthogonalScrollingBehavior = .continuous
            section.decorationItems = [
                NSCollectionLayoutDecorationItem.background(elementKind: "conceptBackground")
            ]
        }
        
        return section
    }
}

// MARK: -- Concept Brand Section

extension HomeModuleCollectionLayoutMaker {
    private func createConceptBottomBrandSection() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .estimated(120))
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let bottomBrandSectionCounter = HomeModuleCollectionLayoutMaker.conceptLayoutBottomSectionDidCreate
        
        if bottomBrandSectionCounter < elementKinds.count {
            let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: elementKinds[bottomBrandSectionCounter])
            backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.decorationItems = [backgroundDecoration]
        }
        
        
        HomeModuleCollectionLayoutMaker.conceptLayoutBottomSectionDidCreate += 1
        
        return section
    }
}

