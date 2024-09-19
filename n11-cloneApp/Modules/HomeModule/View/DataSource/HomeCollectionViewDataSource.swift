    //
    //  HomeCollectionViewDataSource.swift
    //  n11-cloneApp
    //
    //  Created by Bünyamin Mete on 18.08.2024.
    //

    import UIKit

    // MARK: - HomeCollectionViewDataSource

    final class HomeCollectionViewDataSource: HomeScreenDataSource{
        
        init(collectionView: UICollectionView) {
            super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case let item as HomeModuleShortcutBoxPresentationModel:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeModuleShortcutBoxCell.reuseIdentifier, for: indexPath) as! HomeModuleShortcutBoxCell
                    cell.setup(model: item)
                    return cell
                case let item as HomeModuleAutoCarouselPresentationModel:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeModuleAutoCarouselCell.reuseIdentifier, for: indexPath) as! HomeModuleAutoCarouselCell
                    cell.configure(with: item)
                    return cell
                case let item as HomeModuleManuelCarouselPresentationModel:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeModuleManuelCarouselCell.reuseIdentifier, for: indexPath) as! HomeModuleManuelCarouselCell
                    cell.configure(with: item)
                    return cell 
                case let item as HomeModuleProductCardPresentationModel:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeModuleProductCardCell.reuseIdentifier, for: indexPath) as! HomeModuleProductCardCell
                    cell.configureProductCard(with: item)
                    return cell
                case let item as HomeModuleConceptBottomBrandPresentationModel:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeModuleConceptBottomBrandCell.reuseIdentifier, for: indexPath) as! HomeModuleConceptBottomBrandCell
                    cell.setupBrandContainer(with: item)
                    return cell
                    
                default:
                    return nil
                }
            }
            
            collectionView.registerClass(HomeModuleShortcutBoxCell.self)
            collectionView.registerClass(HomeModuleAutoCarouselCell.self)
            collectionView.registerClass(HomeModuleManuelCarouselCell.self)
            collectionView.registerClass(HomeModuleConceptBottomBrandCell.self)
            
            collectionView.registerNib(cellClass: HomeModuleProductCardCell.self)
            
            collectionView.registerHeader(nibName: "HomeModuleProductCardHeaderReusableView", viewType: HomeModuleProductCardHeaderReusableView.self)
            collectionView.registerHeader(viewType: HomeModuleConceptImageHeaderReusableView.self)
        }
    }
