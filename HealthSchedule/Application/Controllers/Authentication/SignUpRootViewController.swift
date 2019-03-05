//
//  SignUpViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SignUpRootViewController: UIViewController {
  
  // test data
  //var signUpData: Parser.JsonDictionary = ["email":"johnsmit@gmail.com", "password":"qwerty123", "first_name":"Ann", "last_name":"Yan", "birthday_at":"2019-01-31", "phone":""]
  private var rootNavigation: RootNavigationController?
  
  private var mainView: MainSignUpInfoView!
  private let model: AuthenticationingModel = UserMainModel()
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! MainSignUpInfoView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    rootNavigation = (self.navigationController as? RootNavigationController)
    
    mainView.setupViews()
    mainView.addTargets()
    
    mainView.nextButton.addTarget(self, action: #selector(onNextClick), for: .touchDown)
  }
  
  func signUp() {
    if !model.validateSignUpData(mainView.collectedData) {
      showAlert(ResponseStatus.invalidData.rawValue)
    }
    
    model.register(userType: mainView.userType, mainView.collectedData) {
      [weak self] error in
      DispatchQueue.main.async {
        if let error = error {
          self!.showAlert(error)
          return
        }
          
        self?.rootNavigation?.presentHome()
      }
    }
  }
  
  // MARK: - Callbacks
  
  @objc func onNextClick() {
    if mainView.userType == .provider {
      rootNavigation?.presentProviderDetailsController()
      return
    }
    
    signUp()
  }
  
  private func showAlert(_ message: String) {
    AlertHandler.ShowAlert(
      for: self,
      "Warning",
      message,
      .alert)
  }
}
