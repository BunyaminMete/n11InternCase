//
//  BackgroundReusableView.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 21.08.2024.
//

import UIKit

struct ColorData: Codable {
    let url: String
    let color: String
}

struct ResponseData: Codable {
    let data: [ColorData]
}

class ColorManager {
    static let shared = ColorManager()
    private init() {}

    private(set) var colorHexStrings: [String] = []

    func fetchColorHexStrings(completion: @escaping () -> Void) {
        let urlString = "https://66b764777f7b1c6d8f1bc48b.mockapi.io/GETImageAndColors"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Veriniz bir dizi olduğu için önce bir dizi oluşturuyoruz
                let responseArray = try JSONDecoder().decode([ResponseData].self, from: data)
                // Dizi içindeki ilk nesnenin 'data' alanını alıyoruz
                if let firstResponse = responseArray.first {
                    self.colorHexStrings = firstResponse.data.map { $0.color }
                }
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

class ShortcutSectionBgView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(named: "purple11") // TopCategoryFilterCell setup for bgcolor
    }
}

class ProductSectionWithCounterBgView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(named: "lightpurple11") // TopCategoryFilterCell setup for bgcolor
    }
}


class ConceptEx1: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        ColorManager.shared.fetchColorHexStrings {
            DispatchQueue.main.async {
                let hexCode = ColorManager.shared.colorHexStrings
                self.backgroundColor = hexCode.isEmpty ? UIColor(named: "purple11") : UIColor(hex: hexCode[0])
            }
        }
    }
}

class ConceptEx2: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        ColorManager.shared.fetchColorHexStrings {
            DispatchQueue.main.async {
                let hexCode = ColorManager.shared.colorHexStrings
                self.backgroundColor = hexCode.isEmpty ? UIColor(named: "purple11") : UIColor(hex: hexCode[1])
            }
        }    }
}


class ConceptEx3: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        ColorManager.shared.fetchColorHexStrings {
            DispatchQueue.main.async {
                let hexCode = ColorManager.shared.colorHexStrings
                self.backgroundColor = hexCode.isEmpty ? UIColor(named: "purple11") : UIColor(hex: hexCode[2])
            }
        }    }
}

class ConceptEx4: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        ColorManager.shared.fetchColorHexStrings {
            DispatchQueue.main.async {
                let hexCode = ColorManager.shared.colorHexStrings
                self.backgroundColor = hexCode.isEmpty ? UIColor(named: "purple11") : UIColor(hex: hexCode[3])
            }
        }
    }
}

class ConceptEx5: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        ColorManager.shared.fetchColorHexStrings {
            DispatchQueue.main.async {
                let hexCode = ColorManager.shared.colorHexStrings
                self.backgroundColor = hexCode.isEmpty ? UIColor(named: "purple11") : UIColor(hex: hexCode[4])
            }
        }
    }
}

