//
//  BasketModuleBuilder.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 14.09.2024.
//

import UIKit

protocol BasketModuleProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class BasketModuleBuilder: BasketModuleProtocol {
    static func createModule() -> UIViewController {
        let view = BasketViewController()
        let interactor = BasketInteractor()
        let presenter = BasketPresenter(
            view: view,
            interactor: interactor
        )

        view.presenter = presenter
        interactor.presenter = presenter

        return view
    }
}
