import UIKit
import FirebaseAuth

final class BasketInteractor: BasketInteractorProtocol{

    var presenter: BasketPresenterProtocol!
    let firestoreNetworking = FirestoreNetworking()

    func requestToGetUsersBasketData() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        firestoreNetworking.fetchBasketItems(forUserUID: userUID) { [weak self] products, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching basket items: \(error.localizedDescription)")
                return
            } else {
                self.presenter?.getUserBasketListSuccess(with: products ?? [])
            }
        }
    }

    func requestToDeleteAllBasketItems() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        firestoreNetworking.deleteAllProducts(forUserUID: userUID) { [weak self] error in
            if let error = error {
                print("Error deleting basket items: \(error.localizedDescription)")
                return
            } else {
                print("All basket items deleted.")
                self?.presenter.deleteAllItemsAndApplyUIChanges()
            }
        }
    }

    func requestToOrderWithCurrentBasket() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        FirestoreNetworking().moveBasketItemsToOrderHistory(forUserUID: userUID) {[weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }
            else
            {
                print("basketProduct collection deleted, orderHistory")
                self?.presenter.userOrderedSuccessfully()
            }
        }
    }

    func requestToCalculateTotalPrice() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        firestoreNetworking.calculateTotalPrice(forUserUID: userUID) { [weak self] totalPrice, error in
            if let error = error {
                print("Error calculating total price: \(error.localizedDescription)")
                return
            }
            self?.presenter.didCalculateTotalPrice(totalPrice ?? 0)
        }
    }

    func requestToCalculateTotalUniqueProduct() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        firestoreNetworking.calculateTotalUniqueProduct(forUserUID: userUID) { [weak self] totalUniqueProductCount, error in
            if let error = error {
                print("Error calculating total unique product count: \(error.localizedDescription)")
                return
            }
            self?.presenter.didCalculateTotalUniqueProductCount(totalUniqueProductCount ?? 0)
        }
    }

}
