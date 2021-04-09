//
//  Dispatch.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 02/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import Foundation

prefix operator ~
postfix operator ~

prefix func ~(_ closure: @escaping (() -> Void)) { runOnBackground(closure) }
postfix func ~(_ closure: @escaping (() -> Void)) { runOnBackground(closure) }
func runOnBackground(_ closure: @escaping (() -> Void)) {
    DispatchQueue.global().async { closure() }
}


prefix operator ^
postfix operator ^


prefix func ^(_ closure: @escaping (() -> Void)) { runOnMain(closure) }
postfix func ^(_ closure: @escaping (() -> Void)) {  runOnMain(closure) }
func runOnMain(_ closure: @escaping (() -> Void)) {
    if Thread.isMainThread { closure(); return }
    DispatchQueue.main.async { closure() }
}


infix operator +

func +(_ closure: @escaping (() -> Void), _ delay: Double) { runAfter(delay, closure) }
func runAfter(_ delay: Double, _ closure: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { closure() }
}
