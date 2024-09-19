//
//  CategoryPageInteractor.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.08.2024.
//

import Foundation

protocol CategoryPageInteractorProtocol: AnyObject{
    func fetchCategories()
}

class CategoryPageInteractor: CategoryPageInteractorProtocol {
    var presenter: CategoryPageInteractorOutputProtocol!
    
    func fetchCategories() {
        let categories = (1..<mockCategories.count).map { "Item \($0)" }
        presenter.categoriesFetched(categories)
    }
    
    
}
