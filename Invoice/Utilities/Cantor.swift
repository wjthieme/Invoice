//
//  Cantor.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 07/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import Foundation

infix operator ><

func ><(_ a: Int, _ b: Int) -> Int { return pair(a, b) }
func pair(_ a: Int, _ b: Int) -> Int {
    return ((a + b) * (a + b + 1) / 2) + b
}

prefix operator <>
postfix operator <>

prefix func <>(_ z: Int) -> (x: Int, y: Int) { return unpair(z) }
postfix func <>(_ z: Int) -> (x: Int, y: Int) { return unpair(z) }
func unpair(_ z: Int) -> (x: Int, y: Int) {
    let d = Double(z)
    let t = Int(floor((sqrt(8 * d + 1) - 1) / 2))
    let x = t * (t + 3) / 2 - z
    let y = z - t * (t + 1) / 2
    
    return (x, y)
}
