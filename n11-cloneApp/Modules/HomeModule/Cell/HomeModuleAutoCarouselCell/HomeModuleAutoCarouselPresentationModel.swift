//
//  HomeModuleAutoCarouselPresentationModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 18.08.2024.
//

import UIKit

struct HomeModuleAutoCarouselPresentationModel: Hashable, Codable {
    let imageName: String

    // `Equatable` protokolü gereği, iki `ImageSliderCellModel` nesnesinin eşitliğini kontrol eden fonksiyon
    static func == (lhs: HomeModuleAutoCarouselPresentationModel, rhs: HomeModuleAutoCarouselPresentationModel) -> Bool {
        return lhs.imageName == rhs.imageName
    }

    // `Hashable` protokolü gereği, nesneyi hash'leyen fonksiyon
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageName)
    }
}

