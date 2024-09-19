import Foundation

final class OrderPresenter: OrderPresenterProtocol {
    weak var view: OrderViewProtocol?
    var interactor: OrderInteractorProtocol?
    var builder: OrderModuleBuilder!

    func fetchOrders() {
        interactor?.fetchOrders()
    }
}

extension OrderPresenter: OrderInteractorOutputProtocol {
    func didFetchOrders(_ orders: [OrdersHistoryPresentationModel]) {
        view?.displayOrders(orders)
    }
}
