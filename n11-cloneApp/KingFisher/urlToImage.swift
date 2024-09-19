//
//  urlToImage.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 13.08.2024.
//


import UIKit
import Kingfisher

func downloadImage(with urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        DispatchQueue.main.async {
            completion(nil)
        }
        return
    }
    let resource = KF.ImageResource(downloadURL: url)

    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
        switch result {
        case .success(let value):
            completion(value.image)
        case .failure(let error):
            print("Error: \(error)")
            completion(nil)
        }
    }
}

extension UIImageView {
    func setImage(from urlString: String) {
        downloadImage(with: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
