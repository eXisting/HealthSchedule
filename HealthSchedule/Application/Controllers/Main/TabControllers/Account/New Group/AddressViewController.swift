//
//  AddressViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView

class AddressViewController: UIViewController {
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
    if !mainView.isValid() {
      showWarningAlert(message: ResponseStatus.passwordsMismatch.rawValue)
      return
    }
    
    model.saveAddress(newAddress: mainView.collectData()) { [weak self] response in
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
