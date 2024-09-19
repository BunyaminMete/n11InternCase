//
//  Formatters.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 16.09.2024.
//

import Foundation

public func formatOrderDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
    dateFormatter.locale = Locale(identifier: "tr_TR")
    return dateFormatter.string(from: date)
}

public func formattedPriceForCell(from price: Double) -> String {
    guard price != 0.0 else {
        return "₺0,00"
    }

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "."
    formatter.decimalSeparator = ","
    formatter.minimumFractionDigits = (price.truncatingRemainder(dividingBy: 1) == 0) ? 0 : 2
    formatter.maximumFractionDigits = 2

    if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
        return "₺\(formattedPrice)"
    }

    return "₺\(price)"
}

public func formattedPrice(from price: Double) -> String {
    guard price != 0.0 else {
        return "0,00 TL"
    }

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "."
    formatter.decimalSeparator = ","
    formatter.minimumFractionDigits = (price.truncatingRemainder(dividingBy: 1) == 0) ? 0 : 2
    formatter.maximumFractionDigits = 2

    if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
        return "\(formattedPrice) TL"
    }

    return "\(price) TL"
}
