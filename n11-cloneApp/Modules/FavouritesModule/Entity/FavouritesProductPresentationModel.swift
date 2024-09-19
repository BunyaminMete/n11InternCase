//
//  FavouritesProductPresentationModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 10.09.2024.
//

import Foundation

struct FavouritesProductPresentationModel: Hashable {
    let productImages: [String]
    let productPrice: String
    let productTitle: String
    let productShipment: Bool
    let productRate: Bool
    let isProductFavourited: Bool
    let amount: String
}
