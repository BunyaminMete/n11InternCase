import Foundation

// MARK: - MainPageInteractor.swift

final class HomeInteractor: HomeInteractorProtocol {
    var sectionList: [any SectionModel] = []
    
    weak var presenter: HomeInteractorOutput?
    
    func getAllSections() -> [any SectionModel] {
        return sectionList
    }
    
    func getSection(at index: Int) -> any SectionModel {
        return sectionList[index]
    }
    
    func getSectionIdentifiers() -> [Section] {
        return sectionList.map { $0.sectionIdentifier }
    }
    
    // MARK: -- LoadSection_Data
    func isDataFetchedFromAPISuccess() {
        presenter?.dataDidUpdate()
        print("Data fetched successfully")
    }
    
    func fetchSectionsFromAPI(completion: @escaping (Result<Void, Error>) -> Void) {
        HomeNetworkManager.shared.fetchSections { [weak self] result in
            guard let self = self else {
                completion(.failure(NSError(domain: "Self is nil", code: -1, userInfo: nil)))
                return
            }
            
            switch result {
            case .success(let jsonArray):
                if let sectionList = self.presenter?.processSections(from: jsonArray) {
                    self.sectionList = sectionList
                    
                    DispatchQueue.main.async {
                        self.isDataFetchedFromAPISuccess()
                        completion(.success(()))
                    }
                } else {
                    completion(.failure(NSError(domain: "Processing error", code: -1, userInfo: nil)))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchImages() {
        HomeNetworkManager.shared.fetchImageUrls { [weak self] urls in
            self?.presenter?.didFetchImageUrls(urls)
        }
    }
    
}

