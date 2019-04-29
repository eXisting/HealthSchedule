//
//  ImagePickerManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/29/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate {
  func populateImageView(with image: UIImage?, named: String?)
  func presentPicker()
}

class ImagePickerController: NSObject {
  private(set) lazy var picker = {
    return UIImagePickerController()
  }()
  
  private(set) var isInitialized: Bool = false

  private var delegate: ImagePickerDelegate!
 
  func setup(delegate: ImagePickerDelegate, with sourceType: UIImagePickerController.SourceType) {
    self.delegate = delegate
    
    isInitialized = true
    picker.delegate = self
    picker.allowsEditing = true
  }
}

extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let chosenImage = info[UIImagePickerController.InfoKey.editedImage]
    let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
    let imageName = imageURL.lastPathComponent
    
    self.delegate.populateImageView(with: chosenImage as? UIImage, named: imageName)
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func open()
  {
    self.delegate.presentPicker()
  }
}
