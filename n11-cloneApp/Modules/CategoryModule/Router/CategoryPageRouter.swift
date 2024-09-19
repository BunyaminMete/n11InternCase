//
//  CategoryPageRouter.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.08.2024.
//

import UIKit

protocol CategoryPageRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class CategoryPageRouter: CategoryPageRouterProtocol {
    static func createModule() -> UIViewController {
        let view = CategoryPageVC()
        let presenter = CategoryPagePresenter()
        let interactor = CategoryPageInteractor()
        let router = CategoryPageRouter()
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}

