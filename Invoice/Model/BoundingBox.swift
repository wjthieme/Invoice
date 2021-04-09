//
//  BoundingBox.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 06/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import CoreGraphics

class BoundingBox<T: Codable>: Codable {

    let x: Double
    let y: Double
    let w: Double
    let h: Double
    let content: T
    
    var rect: CGRect { return CGRect(x: x, y: y, width: w, height: h)}
    
    internal init(x: Double, y: Double, w: Double, h: Double, content: T) {
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.content = content
    }
    
    internal convenience init(frame: CGRect, content: T) {
        self.init(x: Double(frame.origin.x), y: Double(frame.origin.y), w: Double(frame.width), h: Double(frame.height), content: content)
    }
    
}
