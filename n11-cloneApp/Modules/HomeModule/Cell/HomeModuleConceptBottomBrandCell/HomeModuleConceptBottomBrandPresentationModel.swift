//
//  HomeModuleConceptBottomBrandPresentationModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 18.08.2024.
//

import UIKit

struct HomeModuleConceptBottomBrandPresentationModel: Hashable, Codable {
    let brandName: String
    let brandImage: String


    static func == (lhs: HomeModuleConceptBottomBrandPresentationModel, rhs: HomeModuleConceptBottomBrandPresentationModel) -> Bool {
        return lhs.brandName == rhs.brandName &&
               lhs.brandImage == rhs.brandImage
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(brandName)
        hasher.combine(brandImage)
    }
}
