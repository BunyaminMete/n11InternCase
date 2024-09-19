//
//  HomeModuleManuelCarouselPresentationModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 18.08.2024.
//

struct HomeModuleManuelCarouselPresentationModel: Hashable, Codable {
    let imageName: String
    
    static func == (lhs: HomeModuleManuelCarouselPresentationModel, rhs: HomeModuleManuelCarouselPresentationModel) -> Bool {
        return lhs.imageName == rhs.imageName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageName)
    }
}
