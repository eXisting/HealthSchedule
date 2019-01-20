//
//  BlurHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/18/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class BlurHandler {
  
  private static var context = CIContext(options: nil)
  
  static func performBlurOn(_ view: UIImageView) {
    let currentFilter = CIFilter(name: "CIGaussianBlur")
    let beginImage = CIImage(image: view.image!)
    currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
    currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
    
    let cropFilter = CIFilter(name: "CICrop")
    cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
    cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
    
    let output = cropFilter!.outputImage
    let cgimg = context.createCGImage(output!, from: output!.extent)
    let processedImage = UIImage(cgImage: cgimg!)
    view.image = processedImage
  }
}
