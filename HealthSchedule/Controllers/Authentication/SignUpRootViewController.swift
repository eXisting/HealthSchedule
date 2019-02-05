//
//  SignUpViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SignUpRootViewController: UIViewController {
  
  var mainView: MainSignUpInfoView!
  
  override func loadView() {
    super.loadView()
    self.navigationController?.title = "SIGN UP"
    
    mainView = (view as! MainSignUpInfoView)
    mainView.setupViews()
    mainView.nextButton.addTarget(self, action: #selector(onNextClick), for: .touchDown)
  }
  
  @objc func onNextClick() {
    let additionalController = self.storyboard?.instantiateViewController(withIdentifier: "AdditionalSignUp") as! AdditionalInfoSignUpController
    
    self.navigationController?.pushViewController(additionalController, animated: true)
  }
}
