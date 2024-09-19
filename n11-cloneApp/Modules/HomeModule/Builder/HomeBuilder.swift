//
//  Builder.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 13.08.2024.
//

import UIKit

protocol HomeBuilderProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class HomeBuilder: HomeBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = HomeViewController()
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let builder = HomeBuilder()
         
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.builder = builder
        interactor.presenter = presenter
        
        return view
    }
}
