//
//  FirestoreNetworking.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 29.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

class FirestoreNetworking {
    private let db = Firestore.firestore()

    private func getUserProductsCollectionPath(forUserUID userUID: String) -> CollectionReference {
        return db.collection("users").document(userUID).collection("basketProducts")
    }

    private func getUserFavouritesCollectionPath(forUserUID userUID: String) -> CollectionReference {
        return db.collection("users").document(userUID).collection("favouriteProducts")
    }

    private func getOrderHistoryCollectionPath(forUserUID userUID: String) -> CollectionReference {
        return db.collection("users").document(userUID).collection("orderHistory")
    }

    func addProduct(forUserUID userUID: String, product: SavedProductCardPresentationModel, completion: @escaping (Error?) -> Void) {
        let productData: [String: Any] = [
            "productImages": product.productImages,
            "productTitle": product.productTitle,
            "productRate": product.productRate,
            "unitPrice": product.productPrice,
            "productPrice": product.productPrice,
            "freeShipment": product.freeShipment,
            "amount": product.amount,
            "isFavourite": false,
            "createdAt": FieldValue.serverTimestamp()
        ]

        let productsCollection = getUserProductsCollectionPath(forUserUID: userUID)

        productsCollection
            .whereField("productTitle", isEqualTo: product.productTitle)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(error)
                    return
                }

                if let documents = querySnapshot?.documents, !documents.isEmpty {
                    let document = documents.first!
                    let documentId = document.documentID
                    productsCollection.document(documentId).updateData([
                        "amount": FieldValue.increment(Int64(product.amount)),
                        "productPrice": FieldValue.increment(Int64(Double(product.amount) * product.productPrice))
                    ]) { error in
                        completion(error)
                    }
                } else {
                    productsCollection.addDocument(data: productData) { error in
                        completion(error)
                    }
                }
            }
    }

    func addProducts(forUserUID userUID: String, products: [SavedProductCardPresentationModel], completion: @escaping (Error?) -> Void) {
        let group = DispatchGroup()
        var errors: [Error] = []

        for product in products {
            group.enter()
            addProduct(forUserUID: userUID, product: product) { error in
                if let error = error {
                    errors.append(error)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(errors.isEmpty ? nil : errors.first)
        }
    }

    func deleteProduct(forUserUID userUID: String, documentId: String, completion: @escaping (Error?) -> Void) {
        let productsCollection = getUserProductsCollectionPath(forUserUID: userUID)

        productsCollection.document(documentId).delete { error in
            completion(error)
        }
    }

    func updateProductAmount(forUserUID userUID: String, productTitle: String, amount: Int, completion: @escaping (Error?) -> Void) {
        let productsCollection = getUserProductsCollectionPath(forUserUID: userUID)

        productsCollection.whereField("productTitle", isEqualTo: productTitle).getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Product not found."]))
                return
            }

            for document in documents {
                let documentId = document.documentID
                if let unitPrice = document.data()["unitPrice"] as? Double {
                    let newTotalPrice = unitPrice * Double(amount)

                    productsCollection.document(documentId).updateData([
                        "amount": amount,
                        "productPrice": newTotalPrice
                    ]) { error in
                        completion(error)
                    }
                } else {
                    completion(NSError(domain: "", code: 0,
                                       userInfo: [NSLocalizedDescriptionKey: "Unit price not found."]))
                }
            }
        }
    }

    func deleteAllProducts(forUserUID userUID: String, completion: @escaping (Error?) -> Void) {
        let productsCollection = getUserProductsCollectionPath(forUserUID: userUID)

        productsCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }

            let batch = self.db.batch()

            querySnapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }

            batch.commit { error in
                completion(error)
            }
        }
    }

    func fetchBasketItems(forUserUID userUID: String, completion: @escaping ([SavedProductCardPresentationModel]?, Error?) -> Void) {
        let productsCollection = getUserProductsCollectionPath(forUserUID: userUID)

        productsCollection
            .whereField("amount", isGreaterThan: 0)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var products: [SavedProductCardPresentationModel] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let documentId = document.documentID
                        if let product = SavedProductCardPresentationModel(dictionary: data, documentId: documentId) {
                            products.append(product)
                        }
                    }
                    let sortedProducts = products.sorted { $0.creationDate < $1.creationDate }

                    completion(sortedProducts, nil)
                }
            }
    }

    func calculateTotalPrice(forUserUID userUID: String, completion: @escaping (Double?, Error?) -> Void) {
        let productsCollection = getUserProductsCollectionPath(forUserUID: userUID)

        productsCollection
            .whereField("amount", isGreaterThan: 0)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var totalPrice: Double = 0.0
                    for document in querySnapshot!.documents {
                        if let productPrice = document.data()["productPrice"] as? Double {
                            totalPrice += productPrice
                        }
                    }
                    completion(totalPrice, nil)
                }
            }
    }

    func calculateTotalUniqueProduct(forUserUID userUID: String, completion: @escaping (Int?, Error?) -> Void) {
        let productsCollection = getUserProductsCollectionPath(forUserUID: userUID)

        productsCollection
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var totalUniqueProductCount: Int = 0
                    totalUniqueProductCount = (querySnapshot?.documents.count)!
                    completion(totalUniqueProductCount, nil)
                }
            }

    }

    func saveFavouriteProductItemStorage(forUserUID userUID: String, completion: @escaping ([FavouritesProductPresentationModel]?, Error?) -> Void) {
        let _ = getUserProductsCollectionPath(forUserUID: userUID)

    }

    func addProductToFavourites(forUserUID userUID: String, product: SavedProductCardPresentationModel, completion: @escaping (Error?) -> Void) {
        let productData: [String: Any] = [
            "productImages": product.productImages,
            "productTitle": product.productTitle,
            "productRate": product.productRate,
            "unitPrice": product.productPrice,
            "productPrice": product.productPrice,
            "freeShipment": product.freeShipment,
            "amount": product.amount,
            "isFavourite": true,
            "createdAt": FieldValue.serverTimestamp()
        ]

        let collectionPath = getUserFavouritesCollectionPath(forUserUID: userUID)

        collectionPath.whereField("productTitle", isEqualTo: product.productTitle).getDocuments { querySnapshot, error in
            if let error = error {
                completion(error)
                return
            }

            if let documents = querySnapshot?.documents, !documents.isEmpty {
                print("Product with the same title already exists in favourites.")
                completion(nil)
                return
            }

            collectionPath.document(product.productTitle).setData(productData) { error in
                completion(error)
            }
        }
    }

    func removeProductFromFavourites(forUserUID userUID: String, productTitle: String, completion: @escaping (Error?) -> Void) {
        let collectionPath = getUserFavouritesCollectionPath(forUserUID: userUID)

        collectionPath.document(productTitle).delete { error in
            if let error = error {
                completion(error)
            } else {
                print("Product removed from favourites.")
                completion(nil)
            }
        }
    }

    func fetchFavouriteProducts(forUserUID userUID: String, completion: @escaping ([SavedProductCardPresentationModel]?, Error?) -> Void) {
        let productsCollection = getUserFavouritesCollectionPath(forUserUID: userUID)

        productsCollection
            .whereField("isFavourite", isEqualTo: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var products: [SavedProductCardPresentationModel] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let documentId = document.documentID
                        if let product = SavedProductCardPresentationModel(dictionary: data, documentId: documentId) {
                            products.append(product)
                        }
                    }
                    let sortedProducts = products.sorted { $0.creationDate > $1.creationDate }

                    completion(sortedProducts, nil)
                }
            }
    }

    func fetchFavouriteStatus(forUserUID userUID: String, completion: @escaping ([String: Bool]?, Error?) -> Void) {
        let productsCollection = getUserFavouritesCollectionPath(forUserUID: userUID)

        productsCollection
            .whereField("isFavourite", isEqualTo: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var favouriteStatus: [String: Bool] = [:]
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let documentId = document.documentID
                        if let isFavourite = data["isFavourite"] as? Bool {
                            favouriteStatus[documentId] = isFavourite
                        }
                    }
                    completion(favouriteStatus, nil)
                }
            }
    }

    func moveBasketItemsToOrderHistory(forUserUID userUID: String, completion: @escaping (Error?) -> Void) {
        let basketCollection = getUserProductsCollectionPath(forUserUID: userUID)
        let orderHistoryCollection = getOrderHistoryCollectionPath(forUserUID: userUID)

        basketCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No products found in basket."]))
                return
            }

            orderHistoryCollection.order(by: "orderID", descending: true).limit(to: 1).getDocuments { (orderSnapshot, error) in
                if let error = error {
                    completion(error)
                    return
                }

                let lastOrderID = (orderSnapshot?.documents.first?.data()["orderID"] as? Int) ?? 0
                let newOrderID = lastOrderID + 1

                let orderDocumentRef = orderHistoryCollection.document("\(newOrderID)")

                let batch = self.db.batch()

                for document in documents {
                    var productData = document.data()
                    productData["createdAt"] = Timestamp(date: Date())
                    batch.setData(productData, forDocument: orderDocumentRef.collection("products").document(document.documentID))
                    batch.deleteDocument(document.reference)
                }

                batch.setData(["orderID": newOrderID, "createdAt": Timestamp(date: Date())], forDocument: orderDocumentRef)
                batch.commit { error in
                    if let error = error {
                        completion(error)
                    } else {
                        print("Basket items moved to order history successfully.")
                        completion(nil)
                    }
                }
            }
        }
    }



    func fetchProductsFromOrderHistory(forUserUID userUID: String, completion: @escaping ([[OrdersHistoryPresentationModel]]?, Error?) -> Void) {
        let orderHistoryCollection = getOrderHistoryCollectionPath(forUserUID: userUID)

        orderHistoryCollection.getDocuments { (orderSnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            var allOrders: [[OrdersHistoryPresentationModel]] = []

            // Tüm sipariş dökümanları üzerinde dön
            let group = DispatchGroup()

            orderSnapshot?.documents.forEach { orderDocument in
                let productsCollectionRef = orderDocument.reference.collection("products")

                var productsArray: [OrdersHistoryPresentationModel] = []

                group.enter()
                productsCollectionRef.getDocuments { (productSnapshot, error) in
                    defer { group.leave() }

                    if let error = error {
                        completion(nil, error)
                        return
                    }

                    productSnapshot?.documents.forEach { productDocument in
                        let productData = productDocument.data()
                        let timestamp = productData["createdAt"] as? Timestamp
                        let productsOrderDate = timestamp?.dateValue() ?? Date()
                        let product = OrdersHistoryPresentationModel(
                            productImages: productData["productImages"] as? [String] ?? [],
                            productTotalPrice: productData["productPrice"] as? Double ?? 0.0,
                            productsOrderNumber: productData["productsOrderNumber"] as? String ?? "",
                            productsOrderDate: productsOrderDate,
                            productsOrderStatus: productData["productsOrderStatus"] as? String ?? "Sipariş tamamlandı"
                        )
                        productsArray.append(product)
                    }
                    allOrders.append(productsArray)
                }
            }

            group.notify(queue: .main) {
                completion(allOrders, nil)
            }
        }
    }







}
