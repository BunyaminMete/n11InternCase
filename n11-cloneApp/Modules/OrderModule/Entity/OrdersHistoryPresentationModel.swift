//
//  OrdersHistoryPresentationModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 12.09.2024.
//

import Foundation

struct OrdersHistoryPresentationModel: Hashable {
    let id = UUID()
    let productImages: [String]
    let productTotalPrice: Double
    let productsOrderNumber: String
    let productsOrderDate: Date
    let productsOrderStatus: String

    // Varsayılan değerler
    init(productImages: [String] = [],
         productTotalPrice: Double = 0.0,
         productsOrderNumber: String = "",
         productsOrderDate: Date = Date(),
         productsOrderStatus: String = "Sipariş tamamlandı") {
        self.productImages = productImages
        self.productTotalPrice = productTotalPrice
        self.productsOrderNumber = productsOrderNumber
        self.productsOrderDate = productsOrderDate
        self.productsOrderStatus = productsOrderStatus
    }
}


