//
//  FavouritesPresenter.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 15.09.2024.
//

import Foundation

class FavouritesPresenter: FavouritesPresenterProtocol {
    weak var view: FavouritesViewProtocol?
    var interactor: FavouritesInteractorProtocol?
    var builder: FavouritesBuilderProtocol?

    init(view: FavouritesViewProtocol) {
        self.view = view
    }

    func fetchFavouriteProducts() {
        interactor?.fetchFavouriteProducts()
    }

    func fetchFavouriteProductsSuccess(products: [SavedProductCardPresentationModel]) {
        view?.callDisplayFavouriteProducts(products)
    }

    func removeProductFromFavourites(_ productTitle: String) {
        interactor?.removeProductFromFavourites(productTitle)
    }

    func removeProductFromFavouritesSuccess() {
        view?.callShowStatusMessage("Ürün başarıyla favori listesinden silindi.")
        view?.isFavouriteListChanged()
    }

    func addProductToBasket(_ product: SavedProductCardPresentationModel) {
        interactor?.addProductToBasket(product)
    }

    func addProductToBasketSuccess() {
        view?.callShowStatusMessage("Ürün başarıyla sepete eklendi.")
        view?.isFavouriteListChanged()
    }
}
