import UIKit

final class HomePresenter: HomeInteractorOutput, HomePresenterOutput {
    var interactor: HomeInteractorProtocol?
    weak var view: HomeViewProtocol?
    var builder: HomeBuilder!
    
    private var sliderTimer: Timer?
    private var currentIndex = 0
    
    func getCurrentSection(at index: Int) -> (any SectionModel)? {
        return interactor?.getSection(at: index)
    }
    
    func getSectionType(for sectionIndex: Int) -> CellType {
        if let sectionListReference = interactor?.getAllSections() {
            guard !sectionListReference.isEmpty, sectionIndex >= 0, sectionIndex < sectionListReference.count else 
            {
                print("Check section list. It can be empty or index out of range.")
                return .nothing
            }
        }
        let section = interactor!.getSection(at: sectionIndex)
        return section.cellType
    }
    
    //MARK: -- Slider Events
    func startSlider() {
        sliderTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        RunLoop.current.add(sliderTimer!, forMode: .common)
    }
    
    func stopSlider() {
        sliderTimer?.invalidate()
        sliderTimer = nil
    }
    
    @objc private func scrollToNextItem() {
        let numberOfItems = numberOfItemsInSliderSection()
        if numberOfItems > 0 {
            let nextIndex = (currentIndex + 1) % numberOfItems
            currentIndex = nextIndex
            scrollToItem(at: nextIndex)
        }
    }
    
    func numberOfItemsInSliderSection() -> Int {
        return view?.numberOfItemsInSliderSection() ?? 0
    }
    
    func indexOfSliderSection() -> Int? {
        if let sections = interactor?.getAllSections() {
            for (index, section) in sections.enumerated() {
                if section is AutoCarouselSectionModel {
                    return index
                }
            }
        }
        return nil
    }
    

    func scrollToItem(at index: Int) {
        view?.scrollToItem(at: index)
    }
    
    //MARK: -- Slider Events Closed
    func dataDidUpdate() {
        view?.configureDataSource()
        view?.endRefreshEvent()
    }
    
    func requestAPI(completion: @escaping () -> Void) {
        interactor?.fetchSectionsFromAPI {_ in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                [weak self] in
                self?.handleSnapshotWillUpdate()
                self?.startSlider()
                completion()
            }
        }
    }
    
    func didViewCalledPresenterToGetImages(){
        interactor?.fetchImages()
    }
    
    func didFetchImageUrls(_ urls: [String]) {
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for url in urls {
            dispatchGroup.enter()
            downloadImage(with: url) { image in
                if let image = image {
                    images.append(image)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.view?.displayImages(images)
        }
    }

    // MARK: - Snapshot Business
    private func handleSnapshotWillUpdate() {
        guard let dataSource = view?.sendCurrentDataSource() else { return }
        applySnapshot(to: dataSource as! HomeCollectionViewDataSource)
    }
    
    private func applySnapshot(to dataSource: HomeCollectionViewDataSource) {
        var snapshot = HomeScreenSnapshot()
        
        if let sectionIdentifiers = interactor?.getSectionIdentifiers() {
            snapshot.appendSections(sectionIdentifiers)
        }

        if let sectionList = interactor?.getAllSections() {
            for section in sectionList {
                snapshot.appendItems(section.items, toSection: section.sectionIdentifier)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    //MARK: - Appending Section List
    func processSections(from jsonArray: [[String: Any]]) -> [any SectionModel] {
        var sectionList: [any SectionModel] = []
        
        for sectionDict in jsonArray {
            guard let type = sectionDict["type"] as? String,
                  let section = Section(type: type) else { continue }
            
            let jsonData = try? JSONSerialization.data(withJSONObject: sectionDict["items"] ?? [], options: [])
            switch section {
            case .filterSection:
                if let models = try? JSONDecoder().decode([HomeModuleShortcutBoxPresentationModel].self,
                                                          from: jsonData ?? Data()) {
                    sectionList.append(ShortcutBoxSectionModel(shortcutSectionList: models))
                }
            case .sliderSection:
                if let models = try? JSONDecoder().decode([HomeModuleAutoCarouselPresentationModel].self,
                                                          from: jsonData ?? Data()) {
                    sectionList.append(AutoCarouselSectionModel(autoCarouselSectionList: models))
                }
            case .manuelSliderSection:
                if let models = try? JSONDecoder().decode([HomeModuleManuelCarouselPresentationModel].self,
                                                          from: jsonData ?? Data()) {
                    sectionList.append(ManuelCarouselSectionModel(manuelCarouselSectionList: models))
                }
            case .productCardWithHourlyOfferSection:
                if let models = try? JSONDecoder().decode([HomeModuleProductCardPresentationModel].self,
                                                          from: jsonData ?? Data()) {
                    sectionList.append(ProductCardSectionModel(productCardSectionList: models))
                }
            case .productCardWithConceptImageSection:
                if let models = try? JSONDecoder().decode([HomeModuleProductCardPresentationModel].self,
                                                          from: jsonData ?? Data()) {
                    sectionList.append(ConceptTopSectionModel(conceptProductCardSectionList: models))
                }
            case .conceptBottomBrandsSection:
                if let models = try? JSONDecoder().decode([HomeModuleConceptBottomBrandPresentationModel].self,
                                                          from: jsonData ?? Data()) {
                    sectionList.append(ConceptBottomSectionModel(conceptContainerBottomSectionList: models))
                }
            }
        }
        return sectionList
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let section = interactor?.getSection(at: indexPath.section) else { return }
        
        switch section {
        case let filterSection as ShortcutBoxSectionModel:
            print("Selected filter item: \(filterSection.shortcutSectionList[indexPath.row])")
            
        case let sliderSection as AutoCarouselSectionModel:
            print("Selected slider item: \(sliderSection.autoCarouselSectionList[indexPath.row])")
            
        case let manuelSliderSection as ManuelCarouselSectionModel:
            print("Selected manual slider item: \(manuelSliderSection.manuelCarouselSectionList[indexPath.row])")
            
        case let productCardSection as ProductCardSectionModel:
            view?.showProductDetail(product: productCardSection.productCardSectionList[indexPath.row])

        case let conceptTopSection as ConceptTopSectionModel:
            view?.showProductDetail(product: conceptTopSection.conceptProductCardSectionList[indexPath.row])

        case let conceptBottomSection as ConceptBottomSectionModel:
            print("Selected concept bottom brand item: \(conceptBottomSection.conceptContainerBottomSectionList[indexPath.row])")
            
        default:
            print("Unknown section type")
        }
    }
}

extension HomePresenter {
    func headerIdentifier(for type: HeaderType) -> String? {
        switch type {
        case .productCard:
            return HomeModuleProductCardHeaderReusableView.headerIdentifier
        case .conceptArea:
            return HomeModuleConceptImageHeaderReusableView.headerIdentifier
        case .none:
            return nil
        }
    }
    
    func headerTypeForSection(_ section: Int) -> HeaderType {
        switch section {
        case 3:
            return .productCard
        case 4:
            return .conceptArea
        default:
            return .conceptArea
        }
    }
}
