//
//  UICollectionView+Register.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 3.08.2024.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable { }

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(cellClass: T.Type = T.self) {
        let bundle = Bundle(for: cellClass.self)
        if bundle.path(forResource: cellClass.reuseIdentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: cellClass.reuseIdentifier, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
        } else {
            self.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
        }
    }
}



extension UICollectionView {
    
    // Nib ile register etme
    func registerHeader<T: UICollectionReusableView>(nibName: String, viewType: T.Type) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: viewType))
    }
    
    // Sınıf ile register etme
    func registerHeader<T: UICollectionReusableView>(viewType: T.Type) {
        self.register(viewType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: viewType))
    }
    
    // Dequeue etme
    func dequeueHeader<T: UICollectionReusableView>(for indexPath: IndexPath, withReuseIdentifier identifier: String, ofType type: T.Type) -> T? {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as? T
    }
    
    func registerClass<T: UICollectionViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    // Sınıf ile register etme (header ve footer için)
    func registerSupplementaryView<T: UICollectionReusableView>(_ viewClass: T.Type, forSupplementaryViewOfKind kind: String) {
        self.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: viewClass))
    }
}
