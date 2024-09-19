//
//  Array+Ex.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 9.09.2024.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
