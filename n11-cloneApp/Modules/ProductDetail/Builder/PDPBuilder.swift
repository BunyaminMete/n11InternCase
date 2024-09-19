//
//  PDPBuilder.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 15.09.2024.
//

import UIKit

protocol PDPBuilderProtocol: AnyObject {
    static func createModule() -> UIViewController
}

class PDPBuilder: PDPBuilderProtocol{
    static func createModule() -> UIViewController {
        let view = ProductDetailViewController()
        let presenter = ProductDetailPresenter()
        let interactor = ProductDetailInteractor()
        let builder = PDPBuilder()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.builder = builder
        interactor.presenter = presenter

        return view
    }
}
