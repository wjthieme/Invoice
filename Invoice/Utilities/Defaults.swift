//
//  Defaults.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

enum Defaults: String {
    
    case appVersion
    case highscore
    
    func set(_ value: Any) { UserDefaults.standard.set(value, forKey: rawValue) }
    func string() -> String? { UserDefaults.standard.string(forKey: rawValue) }
    func bool() -> Bool { UserDefaults.standard.bool(forKey: rawValue) }
    func int() -> Int { UserDefaults.standard.integer(forKey: rawValue) }
    func double() -> Double { UserDefaults.standard.double(forKey: rawValue) }
}
