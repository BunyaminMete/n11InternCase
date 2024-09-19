//
//  MainPageInteractorOutput.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 5.08.2024.
//

import UIKit

protocol HomePresenterOutput: AnyObject {
    func getCurrentSection(at index: Int) -> (any SectionModel)?
    func headerIdentifier(for type: HeaderType) -> String?
    func headerTypeForSection(_ section: Int) -> HeaderType
    func requestAPI(completion: @escaping () -> Void)
    func numberOfItemsInSliderSection() -> Int
    func scrollToItem(at index: Int)
    func startSlider()
    func stopSlider()
}

protocol HomeInteractorOutput: AnyObject {
    func dataDidUpdate()
    func didFetchImageUrls(_ urls: [String])
    func processSections(from jsonArray: [[String : Any]]) -> [any SectionModel]
}

protocol HomeInteractorProtocol: AnyObject {
    func fetchSectionsFromAPI(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchImages()
    func getAllSections() -> [any SectionModel]
    func getSection(at index: Int) -> any SectionModel
    func getSectionIdentifiers() -> [Section]
}

protocol SectionModel: Hashable, Codable {
    var sectionIdentifier: Section { get }
    var cellType: CellType { get }
    var items: [AnyHashable] { get }
}

protocol HomeViewProtocol: AnyObject {
    func numberOfItemsInSliderSection() -> Int
    func scrollToItem(at index: Int)
    func configureDataSource()
    func endRefreshEvent() 
    func displayImages(_ images: [UIImage])
    func showProductDetail(product: HomeModuleProductCardPresentationModel)
    func sendCurrentDataSource() -> HomeScreenDataSource?
}

protocol SubLabelProgrammaticCollectionViewCellDelegate: AnyObject {
    func didTapCreateOrRegister()
}
