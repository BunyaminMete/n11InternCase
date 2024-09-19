//
//  FirestoreNetworkFavourites.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 10.09.2024.
//

import Foundation
import FirebaseFirestore

class FirestoreNetworkFavourites {
    private let db = Firestore.firestore()

    private func getUserProductsCollectionPath(forUserUID userUID: String) -> CollectionReference {
        return db.collection("users").document(userUID).collection("favouriteProducts")
    }


    func saveFavouriteProductItemStorage(forUserUID userUID: String, completion: @escaping ([FavouritesProductPresentationModel]?, Error?) -> Void) {
        let _ = getUserProductsCollectionPath(forUserUID: userUID)
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

}

