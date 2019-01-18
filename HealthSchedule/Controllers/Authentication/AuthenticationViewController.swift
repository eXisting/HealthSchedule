//
//  LoginViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/16/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
  
  private let signInSegueId = "signIn"
  private let signUpSequeId = "signUp"

  private let opaqueRed = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
  
  let n = "1"
  let p = "2"
  
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    
    blurEffect()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == signInSegueId && !validateFields() {
      AlertHandler.ShowAlert(
        for: self,
        "Validation",
        "Either login or password is incorrect",
        .alert)
      
      emailField.backgroundColor = opaqueRed
      passwordField.backgroundColor = opaqueRed
      
      return false
    }
    
    return true
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: pass data to next view controller
  }
  
  func validateFields() -> Bool {
    // TODO: Call API instead
    return emailField.text == n && passwordField.text == p
  }
  
  var context = CIContext(options: nil)
  
  func blurEffect() {
    
    let currentFilter = CIFilter(name: "CIGaussianBlur")
    let beginImage = CIImage(image: backgroundImage.image!)
    currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
    currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
    
    let cropFilter = CIFilter(name: "CICrop")
    cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
    cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
    
    let output = cropFilter!.outputImage
    let cgimg = context.createCGImage(output!, from: output!.extent)
    let processedImage = UIImage(cgImage: cgimg!)
    backgroundImage.image = processedImage
  }
  
}
