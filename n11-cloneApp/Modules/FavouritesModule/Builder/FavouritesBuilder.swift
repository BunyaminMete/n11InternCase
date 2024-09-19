//
//  FavouritesBuilder.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 14.09.2024.
//

import UIKit

protocol FavouritesBuilderProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class FavouritesBuilder: FavouritesBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = FavouritesViewController()
        let presenter = FavouritesPresenter(view: view)
        let interactor = FavouritesInteractor()
        let builder = FavouritesBuilder()

        view.presenter = presenter
        presenter.interactor = interactor
        presenter.builder = builder
        interactor.presenter = presenter

        return view
    }
}
