//
//  FavouritesContract.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 16.09.2024.
//

import Foundation

protocol FavouritesPresenterProtocol: AnyObject {
    func fetchFavouriteProducts()
    func fetchFavouriteProductsSuccess(products: [SavedProductCardPresentationModel])
    func removeProductFromFavourites(_ productTitle: String)
    func removeProductFromFavouritesSuccess()
    func addProductToBasket(_ product: SavedProductCardPresentationModel)
    func addProductToBasketSuccess()
}

protocol FavouritesInteractorProtocol: AnyObject {
    func fetchFavouriteProducts()
    func removeProductFromFavourites(_ productTitle: String)
    func addProductToBasket(_ product: SavedProductCardPresentationModel)
}

protocol FavouritesViewProtocol: AnyObject {
    func callShowStatusMessage(_ message: String)
    func callDisplayFavouriteProducts(_ products: [SavedProductCardPresentationModel])
    func isFavouriteListChanged()
}
