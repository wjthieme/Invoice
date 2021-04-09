//
//  Animation.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 03/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func gifImageWithData(_ data: Data, fps: Int = 24) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source, fps: fps)
    }
    
    static func gifImageWithURL(_ gifUrl:String, fps: Int = 24) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData, fps: fps)
    }
    
    static func gifImageWithName(_ name: String, fps: Int = 24) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData, fps: fps)
    }
    
    static func animatedImageWithSource(_ source: CGImageSource, fps: Int = 24) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        let images = (0..<count).compactMap { CGImageSourceCreateImageAtIndex(source, $0, nil) }
        let frames = images.map { UIImage(cgImage: $0) }
        let duration = 1 / Double(fps) * Double(count)
        let animation = UIImage.animatedImage(with: frames, duration: duration)
        return animation
    }
}

