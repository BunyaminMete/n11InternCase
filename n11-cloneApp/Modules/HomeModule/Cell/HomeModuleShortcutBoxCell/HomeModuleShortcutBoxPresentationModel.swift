//
//  HomeModuleShortcutBoxPresentationModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 18.08.2024.
//

import UIKit

struct HomeModuleShortcutBoxPresentationModel: Hashable,Codable {
    let title: String
    let imageName: String
    
    // Hashable protokolü için gerekli olan fonksiyonlar
    static func == (lhs: HomeModuleShortcutBoxPresentationModel, rhs: HomeModuleShortcutBoxPresentationModel) -> Bool {
        return lhs.title == rhs.title && lhs.imageName == rhs.imageName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(imageName)
    }
}
