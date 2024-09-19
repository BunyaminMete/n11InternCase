//
//  OrderInteractor.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 14.09.2024.
//

import Foundation
import FirebaseAuth

final class OrderInteractor: OrderInteractorProtocol {
    weak var presenter: OrderInteractorOutputProtocol?

    func fetchOrders() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }

        FirestoreNetworking().fetchProductsFromOrderHistory(forUserUID: userUID) { [weak self] orders, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let orders = orders else {
                    return
                }
                var ordersModified: [OrdersHistoryPresentationModel] = []
                for index in 0..<orders.count {
                    let productDocumentCount = orders[index].count
                    var bubbleImages: [String] = []
                    var totalAmountSpendForEachOrder: Double = 0
                    var storeData: Date = Date()
                    for willCreateBubble in 0..<productDocumentCount {
                        let eachProductTotalOrderedCalculatedPrice = orders[index][willCreateBubble].productTotalPrice
                        storeData = orders[index][willCreateBubble].productsOrderDate
                        totalAmountSpendForEachOrder += eachProductTotalOrderedCalculatedPrice
                        bubbleImages.append(orders[index][willCreateBubble].productImages[0])
                    }
                    ordersModified.append(OrdersHistoryPresentationModel(
                        productImages: bubbleImages,
                        productTotalPrice: totalAmountSpendForEachOrder,
                        productsOrderDate: storeData
                    ))
                }
                self?.presenter?.didFetchOrders(ordersModified)
            }
        }
    }
}
