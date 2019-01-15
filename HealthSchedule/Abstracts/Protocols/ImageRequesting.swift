//
//  ImageRequesting.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ImageRequesting {
  
  func postImage(for url: String, with image: UIImage)
  func getImage(from url: String) -> UIImage?
  
  func getImageAsync(from url: String, completion: @escaping (UIImage?) -> Void)
    
}
