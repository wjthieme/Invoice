//
//  SafeArray.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 06/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
