//
//  FavouritesInteractor.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 15.09.2024.
//

import Foundation
import FirebaseAuth

class FavouritesInteractor: FavouritesInteractorProtocol {
    var presenter: FavouritesPresenterProtocol?
    private let firestoreManager = FirestoreNetworking()

    func fetchFavouriteProducts() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        firestoreManager.fetchFavouriteProducts(forUserUID: userUID) { [weak self] products, error in
            if let error = error {
                print("Error fetching favourite products: \(error.localizedDescription)")
            } else {
                self?.presenter?.fetchFavouriteProductsSuccess(products: products ?? [])
            }
        }
    }

    func removeProductFromFavourites(_ productTitle: String) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Error: User is not logged in.")
            return
        }

        firestoreManager.removeProductFromFavourites(forUserUID: userUID, productTitle: productTitle) { [weak self] error in
            if let error = error {
                print("Error removing product from favourites: \(error.localizedDescription)")
            } else {
                self?.presenter?.removeProductFromFavouritesSuccess()
            }
        }
    }

    func addProductToBasket(_ product: SavedProductCardPresentationModel) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Error: User is not logged in.")
            return
        }

        firestoreManager.addProduct(forUserUID: userUID, product: product) { [weak self] error in
            if let error = error {
                print("Error adding product to basket: \(error.localizedDescription)")
            } else {
                self?.presenter?.addProductToBasketSuccess()
            }
        }
    }
}
