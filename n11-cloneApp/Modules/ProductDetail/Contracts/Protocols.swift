import UIKit

protocol ProductDetailInteractorProtocol: AnyObject {
    func requestForRemoveProductFromFavourites()
    func requestForAddProductToBasket()
    func requestToGetFavouriteStatus()
    func requestToAddProductToFavourites()
    func setProduct(product: HomeModuleProductCardPresentationModel)
}

protocol ProductDetailPresenterProtocol: AnyObject {
    func removeProductFromFavourites()
    func setProductAtPresenter(product: HomeModuleProductCardPresentationModel)
    func didRemoveProductFromFavourites()
    func addProductToBasket()
    func didProductAddedToBasket()
    func didProductAddedToBasketFailure()
    func requestForFavouriteStatusSuccess(with status: [String : Bool]?)
    func requestForFavouriteStatusInformation()
    func requestForAddToFavourites()
    func requestForAddToFavouritesSuccess()
}

protocol ProductDetailPageProtocol: AnyObject{
    func updateFavouriteStatus()
    func setupNavigationItems()
    func updateHeartButton()
    func setProduct()
    func enableButtonAndPushToBasket()
    func forceGuestUserToAuthScreen()
    func favouriteStatusUpdate(with status: [String : Bool]?)
    func updateActionButtonForFavouriteButton()
}
