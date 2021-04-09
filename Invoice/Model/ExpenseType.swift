//
//  ExpenseType.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 04/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import Foundation

enum ExpenseType: String, Codable, CaseIterable {
    case parking, hotel, dinner, travel, misc
    
    var localized: String { return localizedString("\(rawValue)ExpenseType") }
}
