//
//  BasketProductCardPresentationModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 29.08.2024.
//

import UIKit
import FirebaseFirestore


struct SavedProductCardPresentationModel: Hashable {
    let productImages: [String]
    let productTitle: String
    let productRate: Bool
    let productPrice: Double
    let freeShipment: Bool
    let amount: Int
    let creationDate: Date
    let documentId: String
    let isFavourite: Bool

    static func == (lhs: SavedProductCardPresentationModel, rhs: SavedProductCardPresentationModel) -> Bool {
        return lhs.productTitle == rhs.productTitle &&
            lhs.productPrice == rhs.productPrice &&
            lhs.amount == rhs.amount &&
            lhs.productImages == rhs.productImages &&
            lhs.productRate == rhs.productRate &&
            lhs.freeShipment == rhs.freeShipment &&
            lhs.creationDate == rhs.creationDate &&
            lhs.documentId == rhs.documentId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(productTitle)
        hasher.combine(productPrice)
        hasher.combine(amount)
        hasher.combine(productImages)
        hasher.combine(productRate)
        hasher.combine(freeShipment)
        hasher.combine(creationDate)
        hasher.combine(documentId)
    }
}

extension SavedProductCardPresentationModel {
    init?(dictionary: [String: Any], documentId: String) {
        guard
            let productImages = dictionary["productImages"] as? [String],
            let productTitle = dictionary["productTitle"] as? String,
            let productRate = dictionary["productRate"] as? Bool,
            let productPrice = dictionary["productPrice"] as? Double,
            let freeShipment = dictionary["freeShipment"] as? Bool,
            let amount = dictionary["amount"] as? Int,
            let createdAtTimestamp = dictionary["createdAt"] as? Timestamp,
            let isFavourite = dictionary["isFavourite"] as? Bool
        else {
            return nil
        }
        self.productImages = productImages
        self.productTitle = productTitle
        self.productRate = productRate
        self.productPrice = productPrice
        self.freeShipment = freeShipment
        self.amount = amount
        self.creationDate = createdAtTimestamp.dateValue()
        self.documentId = documentId 
        self.isFavourite = isFavourite
    }
}

