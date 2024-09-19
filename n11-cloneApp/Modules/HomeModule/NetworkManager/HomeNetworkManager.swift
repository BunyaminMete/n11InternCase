import UIKit

struct ImageData: Codable {
    let url: String
    let color: String
}

struct ApiResponse: Codable {
    let data: [ImageData]
}

final class HomeNetworkManager {
    static let shared = HomeNetworkManager()
    private init() {}
    
    func fetchSections(completion: @escaping (Result<
                                              [[String: Any]], Error>) -> Void) {
        let urlString = "https://66b764777f7b1c6d8f1bc48b.mockapi.io/CellModels"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    completion(.success(jsonArray))
                } else {
                    completion(.failure(NSError(domain: "Invalid data format", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchImageUrls(completion: @escaping ([String]) -> Void) {
        let urlString = "https://66b764777f7b1c6d8f1bc48b.mockapi.io/GETImageAndColors"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode([ApiResponse].self, from: data)
                let imageUrls = response.first?.data.map { $0.url } ?? []
                completion(imageUrls)
            } catch {
                print("Failed to decode JSON: \(error)")
                completion([])
            }
        }
        
        task.resume()
    }
}
