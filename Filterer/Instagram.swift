//
//  Instagram.swift
//  Filterer
//
//  Created by Arsen Gasparyan on 16/03/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import UIKit

class Instagram {
    
    static let context = CIContext(options: nil)
    static let scale = UIScreen.mainScreen().scale
    
    private let filter: String
    private let deltaKey: String
    
    init(filter: String, deltaKey: String) {
        self.filter = filter
        self.deltaKey = deltaKey
    }
    
    internal func apply(image: UIImage, delta: Float = 0.5) -> UIImage {
        return applyFilter(filter, image: image, deltaKey: deltaKey, deltaValue: delta)
    }
    
//    
//    class func hueAdjust(image: UIImage, delta: Float = 0.5) -> UIImage {
//        return applyFilter("CISepiaTone", image: image, delta: delta)
//    }
//    
//    class func colorCube(image: UIImage, delta: Float = 0.5) -> UIImage {
//        return applyFilter("CIColorCube", image: image, delta: delta)
//    }
    
    
    private func applyFilter(filter: String, image: UIImage, deltaKey: String, deltaValue: Float = 0.5) -> UIImage {
        let inputImage: CIImage! = CIImage(image: image)
        let filteredImage = inputImage.imageByApplyingFilter(filter, withInputParameters: [deltaKey: deltaValue])
        
        let renderedImage = Instagram.context.createCGImage(filteredImage, fromRect: filteredImage.extent)
        return UIImage(CGImage: renderedImage, scale: Instagram.scale, orientation: image.imageOrientation)
    }

}
