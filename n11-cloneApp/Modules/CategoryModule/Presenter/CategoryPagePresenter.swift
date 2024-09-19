//
//  CategoryPagePresenter.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.08.2024.
//

import Foundation

protocol CategoryPagePresenterProtocol: AnyObject {
    func viewDidLoad()
}

protocol CategoryPageInteractorOutputProtocol: AnyObject {
    func categoriesFetched(_ categories: [String])
}

class CategoryPagePresenter: CategoryPagePresenterProtocol, CategoryPageInteractorOutputProtocol {
    weak var view: CategoryPageViewProtocol?
    var interactor: CategoryPageInteractorProtocol!
    var router: CategoryPageRouterProtocol!
    
    func viewDidLoad() {
        interactor.fetchCategories()
    }
    
    func categoriesFetched(_ categories: [String]) {
        view?.displayCategories(categories)
    }
}
