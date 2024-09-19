//
//  OrderBuilder.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 14.09.2024.
//

import UIKit

protocol OrderModuleProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class OrderModuleBuilder: OrderModuleProtocol{
    static func createModule() -> UIViewController {
        let view = OrderHistoryViewController()
        let presenter = OrderPresenter()
        let interactor = OrderInteractor()
        let builder = OrderModuleBuilder()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.builder = builder
        interactor.presenter = presenter

        return view
    }
}
