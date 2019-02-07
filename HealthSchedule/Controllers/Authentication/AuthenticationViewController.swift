//
//  LoginViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/16/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
//  @IBOutlet weak var backgroundImage: UIImageView!
//  @IBOutlet weak var emailField: UITextField!
//  @IBOutlet weak var passwordField: UITextField!
  
  var nav: UINavigationController?
  var mainView: AuthMainView!
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! AuthMainView)
    
    mainView.setUpViews()
    mainView.signInButton.addTarget(self, action: #selector(onSignInClick), for: .touchDown)
    mainView.signUpButton.addTarget(self, action: #selector(onSignUpClick), for: .touchDown)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  @objc func onSignInClick() {
    UserManager.shared.login(login: "xcummerata@example.com", password: "secret") {
      [weak self] error in
      DispatchQueue.main.async {
        if let error = error {
          AlertHandler.ShowAlert(
            for: self!,
            "Warning",
            error,
            .alert)
          
          return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! UITabBarController
        
        self?.present(controller, animated: true, completion: nil)
      }
    }
  }
  
  @objc func onSignUpClick() {
//    let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
//    let controller = storyBoard.instantiateViewController(withIdentifier: "SignUpRoot") as! SignUpRootViewController
//    self.navigationController?.pushViewController(controller, animated: true)
    let body = [
      "email":"somemail@gmail.com",
      "phone":"380507136841",
      "password":"qwerty123",
      "first_name":"Magic name2",
      "last_name":"hehdasdase",
      "birthday_at":"2019-01-31"
    ]
    
//    let profData = ["id":0, "professionId":2, "city_id":1, "companyName":"SomeCompany", "start_at":"2010-11-11 00:00:00", "end_at":"2012-11-11 00:00:00"] as [String : Any]
//
//    let profs = Serializer.getDataFrom(json: profData)
//    let prf = Serializer.decodeDataInto(type: ProviderProfession.self, profs!)

//    let verifies = ["https://images-na.ssl-images-amazon.com/images/I/81W5nfYYxoL._SX425_.jpg"]
//
//    let body = [
//      "email":"johnysd1234@gmail.com",
//      "phone":"123453124512",
//      "password":"qwerty",
//      "first_name":"Magic name2",
//      "last_name":"hehdasdase",
//      "photo":"",
//      "city_id":"2",
//      "birthday":"1999-11-11 00:00:00",
//      "address":"cudo street",
//      "professions":prf,
//      "verifies":""
//      ] as [String : Any]
    
    //let data = Serializer.getDataFrom(json: body)
//
//
    UserManager.shared.register(userType: .client, body) { user in
      print(user)
    }
  }
  
//  private func validatonAlert(_ error: Error?) {
//    AlertHandler.ShowAlert(
//      for: self,
//      "Validation",
//      error?.localizedDescription ?? "Either login or password is incorrect!",
//      .alert)
//
//    emailField.backgroundColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
//    passwordField.backgroundColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
//  }
}
