import UIKit

final class BasketPresenter: BasketPresenterProtocol{

    private unowned let view: BasketViewProtocol
    private let interactor: BasketInteractorProtocol
    var builder: BasketModuleBuilder!

    private var userBasket: [SavedProductCardPresentationModel] = []


    init(view: BasketViewProtocol, interactor: BasketInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }

    //MARK: Fetching Basket List
    func getUserBasketList() {
        interactor.requestToGetUsersBasketData()
    }

    func getUserBasketListSuccess(with products: [SavedProductCardPresentationModel]) {
        self.userBasket = products
        view.fetchUserBasketListAndUpdate(with: products)
    }

    //MARK: Deleting Basket Items
    func requestToDeleteBasketItems() {
        interactor.requestToDeleteAllBasketItems()
    }

    func deleteAllItemsAndApplyUIChanges() {
        view.updateEmptyBasketViewController()
    }

    func userWantsToOrder() {
        interactor.requestToOrderWithCurrentBasket()
    }

    func userOrderedSuccessfully() {
        view.updateEmptyBasketViewController()
    }

    func requestTotalPriceAndProductCount() {
        interactor.requestToCalculateTotalPrice()
        interactor.requestToCalculateTotalUniqueProduct()
    }

    func didCalculateTotalPrice(_ totalPrice: Double) {
        view.updateTotalPrice(formattedPriceForCell(from: totalPrice))
    }

    func didCalculateTotalUniqueProductCount(_ totalUniqueProductCount: Int) {
        view.updateTotalProductCount("Ödenecek Tutar (\(totalUniqueProductCount) Ürün)")
    }
}
