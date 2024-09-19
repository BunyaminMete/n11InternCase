//
//  OrderContracts.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 16.09.2024.
//

import Foundation

protocol OrderPresenterProtocol: AnyObject {
    func fetchOrders()
}

protocol OrderInteractorProtocol: AnyObject {
    func fetchOrders()
}

protocol OrderViewProtocol: AnyObject {
    func displayOrders(_ orders: [OrdersHistoryPresentationModel])
}

protocol OrderInteractorOutputProtocol: AnyObject {
    func didFetchOrders(_ orders: [OrdersHistoryPresentationModel])
}
