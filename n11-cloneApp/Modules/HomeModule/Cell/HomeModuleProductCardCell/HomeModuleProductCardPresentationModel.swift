//
//  HomeModuleProductCardPresentationModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 18.08.2024.
//

import UIKit

struct HomeModuleProductCardPresentationModel: Hashable, Codable {
    let productImages: [String]
    let productTitle: String
    let productRate: Bool
    let productPrice: Double
    let freeShipment: Bool

    // `Equatable` protokolü gereği, iki `ProductCardCellModel` nesnesinin eşitliğini kontrol eden fonksiyon
    static func == (lhs: HomeModuleProductCardPresentationModel, rhs: HomeModuleProductCardPresentationModel) -> Bool {
        return  lhs.productRate == rhs.productRate &&
               lhs.productPrice == rhs.productPrice &&
               lhs.freeShipment == rhs.freeShipment
    }

    // `Hashable` protokolü gereği, nesneyi hash'leyen fonksiyon
    func hash(into hasher: inout Hasher) {
        hasher.combine(productRate)
        hasher.combine(productPrice)
        hasher.combine(freeShipment)
    }
}
