//
//  TopCategoryFilterCell.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 3.08.2024.
//

import Foundation

// MARK: - Sections
struct ShortcutBoxSectionModel: SectionModel {
    var sectionIdentifier: Section = .filterSection(identifier: UUID())
    var shortcutSectionList: [HomeModuleShortcutBoxPresentationModel]
    
    var items: [AnyHashable] {
        return shortcutSectionList
    }
    
    var cellType: CellType {
        return .shortcutBoxSectionCell
    }
    
    static func == (lhs: ShortcutBoxSectionModel, rhs: ShortcutBoxSectionModel) -> Bool {
        return lhs.shortcutSectionList == rhs.shortcutSectionList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(shortcutSectionList)
    }
}

struct AutoCarouselSectionModel: SectionModel {
    var sectionIdentifier: Section = .sliderSection(identifier: UUID())
    var autoCarouselSectionList: [HomeModuleAutoCarouselPresentationModel]
    
    var items: [AnyHashable] {
        return autoCarouselSectionList
    }
    
    var cellType: CellType {
        return .autoCarouselSectionCell
    }
    
    static func == (lhs: AutoCarouselSectionModel, rhs: AutoCarouselSectionModel) -> Bool {
        return lhs.autoCarouselSectionList == rhs.autoCarouselSectionList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(autoCarouselSectionList)
    }
}

struct ManuelCarouselSectionModel: SectionModel {
    var sectionIdentifier: Section = .manuelSliderSection(identifier: UUID())
    var manuelCarouselSectionList: [HomeModuleManuelCarouselPresentationModel]
    
    
    var items: [AnyHashable] {
        return manuelCarouselSectionList
    }
    
    var cellType: CellType {
        return .manuelCarouselSectionCell
    }
    
    static func == (lhs: ManuelCarouselSectionModel, rhs: ManuelCarouselSectionModel) -> Bool {
        return lhs.manuelCarouselSectionList == rhs.manuelCarouselSectionList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(manuelCarouselSectionList)
    }
}

struct ProductCardSectionModel: SectionModel {
    var sectionIdentifier: Section = .productCardWithHourlyOfferSection(identifier: UUID())
    var productCardSectionList: [HomeModuleProductCardPresentationModel]

    var cellType: CellType {
        return .productCardSectionCell
    }
    
    var items: [AnyHashable] {
        return productCardSectionList
    }
    
    static func == (lhs: ProductCardSectionModel, rhs: ProductCardSectionModel) -> Bool {
        return lhs.productCardSectionList == rhs.productCardSectionList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(productCardSectionList)
    }
}

struct ConceptTopSectionModel: SectionModel {
    var sectionIdentifier: Section = .productCardWithConceptImageSection(identifier: UUID())
    var conceptProductCardSectionList: [HomeModuleProductCardPresentationModel]
    
    var cellType: CellType {
        return .conceptContainerUpperSectionCell
    }
    
    var items: [AnyHashable] {
        return conceptProductCardSectionList
    }
    
    static func == (lhs: ConceptTopSectionModel, rhs: ConceptTopSectionModel) -> Bool {
        return lhs.sectionIdentifier == rhs.sectionIdentifier &&
               lhs.conceptProductCardSectionList == rhs.conceptProductCardSectionList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sectionIdentifier)
        hasher.combine(conceptProductCardSectionList)
    }
}

struct ConceptBottomSectionModel: SectionModel {
    var sectionIdentifier: Section = .conceptBottomBrandsSection(identifier: UUID())
    var conceptContainerBottomSectionList: [HomeModuleConceptBottomBrandPresentationModel]
    
    var cellType: CellType {
        return .conceptContainerBottomSectionCell
    }
    
    var items: [AnyHashable] {
        return conceptContainerBottomSectionList
    }
    
    static func == (lhs: ConceptBottomSectionModel, rhs: ConceptBottomSectionModel) -> Bool {
        return lhs.conceptContainerBottomSectionList == rhs.conceptContainerBottomSectionList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(conceptContainerBottomSectionList)
    }
}
