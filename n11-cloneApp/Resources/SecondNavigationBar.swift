//
//  SecondNavigationBar.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 12.08.2024.
//

import UIKit

class SecondNavigationBar: UIView {

    @IBOutlet weak var containerView: UIView! // XIB'deki ana view
    @IBOutlet weak var navigationTitle: UINavigationBar!

    // XIB'den yükleme işlemi
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        private func commonInit() {
            // XIB dosyasını yükle ve view ile ilişkilendir
            Bundle.main.loadNibNamed("SecondNavigationBar", owner: self, options: nil)
            addSubview(containerView)
            containerView.frame = self.bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

