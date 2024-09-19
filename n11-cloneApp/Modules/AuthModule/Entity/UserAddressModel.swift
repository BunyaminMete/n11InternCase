//
//  UserAddressModel.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 7.09.2024.
//

import UIKit

struct UserAddressModel {
    let userCountry: String
    let userCity: String
    let userPostCode: String
    let userStreet: String
    let userDistrict: String
    let userStructureNo: String
}

struct AddressModel: Hashable {
    let id: String
    let addressTitle: String
    let addressFull: String
}

