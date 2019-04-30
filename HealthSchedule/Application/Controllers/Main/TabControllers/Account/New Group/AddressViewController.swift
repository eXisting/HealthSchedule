//
//  AddressViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

class AddressViewController: UIViewController, NVActivityIndicatorViewable  {
  private let titleName = "Your address"
  
  private let mainView = AddressView()
  private let model = AddressModel()
  
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
    
    fetchAddress()
    
    setupNavigationBarAppearance()
    hideKeyboardWhenTappedAround()
  }
  
  private func fetchAddress() {
    DispatchQueue.global(qos: .userInteractive).sync {
      self.mainView.setup(self.model.getAddress())
    }
  }
  
  private func setupNavigationBarAppearance() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.backgroundColor = .gray
  }
  
  private func showLoader() {
    let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
    startAnimating(size, type: .ballScaleRipple, color: .white, backgroundColor: UIColor.black.withAlphaComponent(0.75))
  }
}

extension AddressViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension AddressViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension AddressViewController: GeneralItemHandlingDelegate {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    showLoader()
    
    if !mainView.isValid() {
      showWarningAlert(message: ResponseStatus.passwordsMismatch.rawValue)
      return
    }
    
    model.saveAddress(newAddress: mainView.collectData()) { [weak self] response in
      DispatchQueue.main.async {
        self?.stopAnimating()
      }
      
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.showWarningAlert(message: response)
        }
      }
      
      DispatchQueue.main.async {
        self?.back()
      }
    }
  }
}
