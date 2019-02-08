//
//  DetailedSignUpViewController.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 1/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderSignUpViewController: UIViewController {
  
  private var mainView: ProviderInfoView!
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! ProviderInfoView)
    mainView.setupViews()
    
    // TODO: Add image choose action
    
    mainView.nextButton.addTarget(self, action: #selector(signUp), for: .touchDown)
  }
  
  @objc func signUp() {
    // TODO: NOT WORKING WITHOUT multipart upload 
    
//    let root = self.navigationController?.viewControllers[1] as! SignUpRootViewController

//    UserManager.shared.register(userType: .provider, root.signUpData) {
//      [weak self] error in
//      DispatchQueue.main.async {
//        if let error = error {
//          self!.showAlert("Warning", error)
//          return
//        }
//
//        self!.showAlert("Success", UserMessage.accountModeration.rawValue)
//        self!.navigationController?.popToRootViewController(animated: true)
//      }
//    }
  }
  
  private func showAlert(_ title: String, _ message: String) {
    AlertHandler.ShowAlert(
      for: self,
      title,
      message,
      .alert)
  }
}
