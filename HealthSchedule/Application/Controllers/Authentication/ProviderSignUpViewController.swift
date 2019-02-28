//
//  DetailedSignUpViewController.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 1/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderSignUpViewController: UIViewController {
  
  private var root: SignUpRootViewController!
  private var mainView: ProviderInfoView!
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! ProviderInfoView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.setupViews()
    
    // TODO: Add image choose action
    
    root = (self.navigationController?.viewControllers[1] as! SignUpRootViewController)
    mainView.nextButton.addTarget(self, action: #selector(signUp), for: .touchDown)
  }
  
  @objc func signUp() {
    root.signUp()
    // TODO: NOT WORKING WITH VERIFY WITHOUT multipart upload - mock image selection until it will be fixed
//    UserManager.shared.register(userType: .provider, root.mainView.data) {
//      [weak self] error in
//      DispatchQueue.main.async {
//        if let error = error {
//          self!.showAlert("Warning", error)
//          return
//        }
//
//        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
//        self!.present(controller, animated: true)
//      }
//    }
  }
}
