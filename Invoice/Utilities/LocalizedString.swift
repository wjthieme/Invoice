//
//  LocalizedString.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

func localizedString(_ key: String, _ options: String...) -> String {
    var string = NSLocalizedString(key, comment: "")
    (0..<options.count).forEach { string = string.replacingOccurrences(of: "%\($0)", with: options[$0]) }
    return string
}

func localizedDate(_ date: Date, dateStyle: DateFormatter.Style = .none, timeStyle: DateFormatter.Style = .none) -> String {
    let formatter = DateFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.dateStyle = dateStyle
    formatter.timeStyle = timeStyle
    
    formatter.locale = Locale.current
    return formatter.string(from: date)
}

func localizedCurrency(_ amount: Float, _ currency: String) -> String {
    let rounded = String(format: "%.2f", amount)
    let symbol = currencySymbol(currency) ?? currency
    return "\(symbol) \(rounded)"
}

func currencySymbol(_ code: String) -> String? {
    let locale = NSLocale(localeIdentifier: code)
    if locale.displayName(forKey: .currencySymbol, value: code) == code {
        let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
        return newlocale.displayName(forKey: .currencySymbol, value: code) ?? code
    }
    return locale.displayName(forKey: .currencySymbol, value: code)
}
