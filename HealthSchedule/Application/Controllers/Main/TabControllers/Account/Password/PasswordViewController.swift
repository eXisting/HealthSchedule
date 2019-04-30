//
//  PasswordViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

class PasswordViewController: UIViewController, NVActivityIndicatorViewable {
  private let titleName = "Change password"
  
  private let mainView = PasswordView()
  private let model = PasswordModel()
  
  private var customNavigationItem: GeneralActionSaveNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = GeneralActionSaveNavigationItem(title: titleName, delegate: self, type: .save)
      }
      
      return customNavigationItem!
    }
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.set(textFieldsDelegate: self)
    setupNavigationBarAppearance()
    
    hideKeyboardWhenTappedAround()
  }
  
  private func setupNavigationBarAppearance() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.backgroundColor = .gray
  }
  
  private func showLoader() {
    let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
    startAnimating(size, type: .ballScaleRipple, color: .white, backgroundColor: UIColor.black.withAlphaComponent(0.75))
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: { [weak self] in
      if self!.isAnimating {
        self?.stopAnimating()
      }
    })
  }
}

extension PasswordViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    if isAnimating {
      stopAnimating()
    }
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension PasswordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension PasswordViewController: GeneralItemHandlingDelegate {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    showLoader()
    
    if !mainView.isConfirmValid() {
      showWarningAlert(message: ResponseStatus.passwordsMismatch.rawValue)
      return
    }
    
    model.save(with: mainView.collectData()) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.showWarningAlert(message: response)
        }
      }
      
      DispatchQueue.main.async {
        self?.showLoader()
        self?.back()
      }
    }
  }
}
