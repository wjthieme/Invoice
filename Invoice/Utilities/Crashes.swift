//
//  Error.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 06/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import Foundation
import Crashlytics

class Crashes {
    static let crashlytics = Crashlytics.sharedInstance()
    
    static func log(error: Error) {
        crashlytics.recordError(error)
    }
}
