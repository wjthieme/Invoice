//
//  Amount.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 05/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import Foundation

class Money: Codable {
    let amount: Float
    let currency: String
    
    internal init(amount: Float = 0, currency: String = "EUR") {
        self.amount = amount
        self.currency = currency
    }
    
    func exchangedToDefault() -> Float? {
        return ExchangeService.exchange(amount, from: currency)
    }
    
    var localized: String { localizedCurrency(amount, currency) }

}
