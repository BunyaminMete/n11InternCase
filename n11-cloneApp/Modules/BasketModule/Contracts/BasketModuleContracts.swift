//
//  BasketModuleContracts.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 9.09.2024.
//

import Foundation

protocol BasketToPDP: AnyObject {
    func showProductDetail(product: HomeModuleProductCardPresentationModel)
}

protocol BasketPresenterProtocol: AnyObject {
    func getUserBasketList()
    func getUserBasketListSuccess(with products: [SavedProductCardPresentationModel])
    func requestToDeleteBasketItems()
    func deleteAllItemsAndApplyUIChanges()
    func userWantsToOrder()
    func userOrderedSuccessfully()

    func requestTotalPriceAndProductCount()
    func didCalculateTotalPrice(_ totalPrice: Double)
    func didCalculateTotalUniqueProductCount(_ totalUniqueProductCount: Int)
}

protocol BasketInteractorProtocol: AnyObject {
    func requestToGetUsersBasketData()
    func requestToDeleteAllBasketItems()
    func requestToOrderWithCurrentBasket()

    func requestToCalculateTotalPrice()
    func requestToCalculateTotalUniqueProduct()
}

protocol BasketViewProtocol: AnyObject {
    func fetchUserBasketListAndUpdate(with product: [SavedProductCardPresentationModel])
    func updateEmptyBasketViewController()

    func updateTotalPrice(_ totalPrice: String)
    func updateTotalProductCount(_ totalProductCountText: String)
}

