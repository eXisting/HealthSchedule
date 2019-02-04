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
  
  override func loadView() {
    super.loadView()
    
    (view as! AuthMainView).setUpViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    // TODO: wait until data received
    UserManager.shared.login(login: "kylee69@example.net", password: "secret") { user in
      print("Perform segue")
      
      UserManager.shared.saveAddress("Super new address") { text in
        print(text)
      }
    }
    return false
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: pass data to next view controller
  }
  
  func signUp(errorHandler: @escaping (Error?) -> Void) {
//    let body = [
//      "email":"johny1234@gmail.com",
//      "phone":"123453124512",
//      "password":"qwerty",
//      "first_name":"Magic name2",
//      "last_name":"hehdasdase",
//      "photo":"",
//      "city_id":"2",
//      "birthday":"1999-11-11 00:00:00"
//    ]
    
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    guard let start = dateFormatter.date(from: "2010-11-11 00:00:00") else {
//      fatalError("ERROR: Date conversion failed due to mismatched format.")
//    }
//    guard let end = dateFormatter.date(from: "2012-11-11 00:00:00") else {
//      fatalError("ERROR: Date conversion failed due to mismatched format.")
//    }
//
//    let prof = ProviderProfession(id: 0, providerId: 2, professionId: 2, cityId: 1, companyName: "SomeCompany", startAt: start, endAt: end)
//
//
//    let verifies = ["https://images-na.ssl-images-amazon.com/images/I/81W5nfYYxoL._SX425_.jpg"]
//
//    let body = [
//      "email":"johny1234@gmail.com",
//      "phone":"123453124512",
//      "password":"qwerty",
//      "first_name":"Magic name2",
//      "last_name":"hehdasdase",
//      "photo":"",
//      "city_id":"2",
//      "birthday":"1999-11-11 00:00:00",
//      "address":"cudo street",
//      "professions":[prof.asJsonObject()],
//      "verifies":""
//      ] as [String: Any]
//
//
//    RequestManager.signUp(authType: .provider, body: body) { [weak self] (userData, error) in
//      // TODO: store it and pass to another controlelr in case when error is nil
//      guard let user = userData as? User else {
//        errorHandler(error)
//        return
//      }
//
//      print(user)
//    }
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
