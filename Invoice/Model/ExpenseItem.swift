//
//  ExpenseItem.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 04/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import Foundation

class ExpenseItem: Codable {
    
    let titles: [BoundingBox<String>]
    var title: String?
    
    let amounts: [BoundingBox<Money>]
    var amount: Money?
    
    let dates: [BoundingBox<Date>]
    var date: Date?
    
    let image: Data
    
    internal init(titles: [BoundingBox<String>], amounts: [BoundingBox<Money>], dates: [BoundingBox<Date>], image: Data) {
        self.titles = titles
        self.amounts = amounts
        self.dates = dates
        self.image = image
    }
    
}
