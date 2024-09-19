import UIKit
import FirebaseAuth

class ProductDetailPresenter: ProductDetailPresenterProtocol {
    weak var view: ProductDetailPageProtocol?
    var interactor: ProductDetailInteractorProtocol!
    var builder: PDPBuilder?
    var product: HomeModuleProductCardPresentationModel?

    func setProductAtPresenter(product: HomeModuleProductCardPresentationModel) {
        self.product = product
        interactor?.setProduct(product: self.product!)
    }

    //MARK: Remove Product
    func removeProductFromFavourites() {
        interactor?.requestForRemoveProductFromFavourites()
    }

    func didRemoveProductFromFavourites() {
        view?.updateFavouriteStatus()
        view?.setupNavigationItems()
        view?.updateHeartButton()
    }

    //MARK: Add Product To Basket
    func addProductToBasket() {
        interactor?.requestForAddProductToBasket()
    }

    func didProductAddedToBasket() {
        view?.enableButtonAndPushToBasket()
    }

    func didProductAddedToBasketFailure() {
        view?.forceGuestUserToAuthScreen()
    }

    //MARK: Request To Get Favourite Status
    func requestForFavouriteStatusInformation(){
        interactor?.requestToGetFavouriteStatus()
    }

    func requestForFavouriteStatusSuccess(with status: [String : Bool]?) {
        view?.favouriteStatusUpdate(with: status)
    }

    //MARK: Request To Favourite Product
    func requestForAddToFavourites(){
        interactor.requestToAddProductToFavourites()
    }

    func requestForAddToFavouritesSuccess(){
        view?.updateActionButtonForFavouriteButton()
    }

}
