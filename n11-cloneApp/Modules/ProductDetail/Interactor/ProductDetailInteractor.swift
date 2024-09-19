import UIKit
import FirebaseAuth

class ProductDetailInteractor: ProductDetailInteractorProtocol {
    weak var presenter: ProductDetailPresenterProtocol?
    var product: HomeModuleProductCardPresentationModel?
    let firestoreManager = FirestoreNetworking()

    func setProduct(product: HomeModuleProductCardPresentationModel) {
        self.product = product
    }

    func requestForRemoveProductFromFavourites() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Error: User is not logged in.")
            return
        }

        firestoreManager.removeProductFromFavourites(forUserUID: userUID, productTitle: product!.productTitle) { [weak self] error in
            if let error = error {
                print("Error removing product from favourites \(error.localizedDescription)")
                return
            } else {
                print("Removed successfully")
                // Notify presenter that the operation was successful
                self?.presenter?.didRemoveProductFromFavourites()
            }
        }
    }

    func requestForAddProductToBasket() {
        guard let product = product else {
            return
        }

        let basketProduct = SavedProductCardPresentationModel(
            productImages: product.productImages,
            productTitle: product.productTitle,
            productRate: product.productRate,
            productPrice: product.productPrice,
            freeShipment: product.freeShipment,
            amount: 1,
            creationDate: Date(),
            documentId: "",
            isFavourite: false
        )

        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Error: User is not logged in.")
            presenter?.didProductAddedToBasketFailure()
            return
        }

        firestoreManager.addProduct(forUserUID: userUID, product: basketProduct) { error in
            if let error = error
            {
                print("Error adding product: \(error.localizedDescription)")
                self.presenter?.didProductAddedToBasketFailure()
            }
            else
            {
                print("Product added successfully.")
                self.presenter?.didProductAddedToBasket()
            }
        }
    }

    func requestToGetFavouriteStatus() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        firestoreManager.fetchFavouriteStatus(forUserUID: userUID) { status, error in
            if let error = error {
                print("Error fetching favourite status: \(error.localizedDescription)")
            } else if let status = status {
                self.presenter?.requestForFavouriteStatusSuccess(with: status)
            }
        }
    }

    func requestToAddProductToFavourites() {
        guard let product = product else { return }

        let favouriteProduct = SavedProductCardPresentationModel(
            productImages: product.productImages,
            productTitle: product.productTitle,
            productRate: product.productRate,
            productPrice: product.productPrice,
            freeShipment: product.freeShipment,
            amount: 1,
            creationDate: Date(),
            documentId: "",
            isFavourite: true
        )

        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Error: User is not logged in.")
            return
        }
        // Ürünü Firestore'a favorilere ekle
        firestoreManager.addProductToFavourites(forUserUID: userUID, product: favouriteProduct) { error in
            if let error = error {
                print("Error adding product to favourites: \(error.localizedDescription)")
            } else {
                print("Product added to favourites successfully.")
                self.presenter?.requestForAddToFavouritesSuccess()
            }
        }

    }

}
