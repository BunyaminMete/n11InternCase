//
//  HomeCollectionViewDataSourceable.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 18.08.2024.
//

import UIKit

// MARK: - Section

enum Section: Hashable, Codable {
    case filterSection(identifier: UUID = UUID())
    case sliderSection(identifier: UUID = UUID())
    case manuelSliderSection(identifier: UUID = UUID())
    case productCardWithHourlyOfferSection(identifier: UUID = UUID())
    case productCardWithConceptImageSection(identifier: UUID = UUID())
    case conceptBottomBrandsSection(identifier: UUID = UUID())
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .filterSection(let id),
             .sliderSection(let id),
             .manuelSliderSection(let id),
             .productCardWithHourlyOfferSection(let id),
             .productCardWithConceptImageSection(let id),
             .conceptBottomBrandsSection(let id):
            hasher.combine(id)
        }
    }

    static func == (lhs: Section, rhs: Section) -> Bool {
        switch (lhs, rhs) {
        case (.filterSection(let id1), .filterSection(let id2)),
             (.sliderSection(let id1), .sliderSection(let id2)),
             (.manuelSliderSection(let id1), .manuelSliderSection(let id2)),
             (.productCardWithHourlyOfferSection(let id1), .productCardWithHourlyOfferSection(let id2)),
             (.productCardWithConceptImageSection(let id1), .productCardWithConceptImageSection(let id2)),
             (.conceptBottomBrandsSection(let id1), .conceptBottomBrandsSection(let id2)):
            return id1 == id2
        default:
            return false
        }
    }

    init?(type: String) {
        switch type {
        case "filterSection":
            self = .filterSection()
        case "sliderSection":
            self = .sliderSection()
        case "manuelSliderSection":
            self = .manuelSliderSection()
        case "productCardSection":
            self = .productCardWithHourlyOfferSection()
        case "conceptTopContainerSection":
            self = .productCardWithConceptImageSection()
        case "conceptBottomContainerSection":
            self = .conceptBottomBrandsSection()
        default:
            return nil
        }
    }
}

// MARK: - CellType
enum CellType: Hashable, Codable {
    case shortcutBoxSectionCell
    case autoCarouselSectionCell
    case manuelCarouselSectionCell
    case productCardSectionCell
    case conceptContainerUpperSectionCell
    case conceptContainerBottomSectionCell
    case nothing
}

// MARK: - Type Alias

typealias HomeScreenDataSource = UICollectionViewDiffableDataSource<
    Section, AnyHashable
>
typealias HomeScreenSnapshot = NSDiffableDataSourceSnapshot<
    Section, AnyHashable
>
