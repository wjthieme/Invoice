//
//  ExpenseList.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 04/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import Foundation

class ExpenseList: Codable {
    
    let items: Array<ExpenseItem>
    let type: ExpenseType
    let createdDate: Date = Date()
    
    internal init(items: Array<ExpenseItem>, type: ExpenseType) {
        self.items = items
        self.type = type
    }
    
}
