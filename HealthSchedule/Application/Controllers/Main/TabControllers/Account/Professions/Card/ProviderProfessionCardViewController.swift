//
//  ProviderProfessionCardViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import Presentr

class ProviderProfessionCardViewController: UIViewController {
  private let titleName = "Add new experience"
  
  private var model: ProviderProfessionModel!
  private let mainView = ProviderProfessionElementTableView()
  
  private var customNavigationItem: GeneralActionSaveNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = GeneralActionSaveNavigationItem(title: titleName, delegate: self, type: .save)
      }
      
      return customNavigationItem!
    }
  }
  
  convenience init(profession: ProviderProfession?) {
    self.init()
    model = ProviderProfessionModel(profession: profession)
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    model.dataSource.textFieldDelegate = self
    mainView.setup(delegate: self, dataSource: model.dataSource)
    
    model.instantiateData()
  }
  
  private func presentProfessionsPicker(with identifier: IndexPath) {
    model.getProfessions {
      [weak self] professions in
      DispatchQueue.main.async {
        // TODO
      }
    }
  }
  
  private func presentCityPicker(with identifier: IndexPath) {
    model.getCities {
      [weak self] cities in
      DispatchQueue.main.async {
        // TODO
      }
    }
  }
}

extension ProviderProfessionCardViewController: ModalPickHandling {
  func picked(id: Int, title: String) {
    guard let path = model.serviceIdentifier else { return }
    
    // TODO
    
    DispatchQueue.main.async {
      self.mainView.reloadRows(at: [path], with: .automatic)
    }
  }
}

extension ProviderProfessionCardViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return model[section].sectionHeight
  }
}

extension ProviderProfessionCardViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    guard let identifyingTextField = textField as? IdentifyingTextField,
      let indexPath = identifyingTextField.identifier else {
        return true
    }
    
    switch identifyingTextField.subType {
    case .datePicker:
      identifyingTextField.aciton?()
      return true
    case .professionPicker:
      presentProfessionsPicker(with: indexPath)
      return false
    case .cityPicker:
      presentCityPicker(with: indexPath)
      return false
    case .servicePicker, .none:
      return true
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let identifyingTextField = textField as? IdentifyingTextField,
      let identifier = identifyingTextField.identifier else {
        return
    }
    
    model.changeText(by: identifier, with: identifyingTextField.text)
  }
}

extension ProviderProfessionCardViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}


extension ProviderProfessionCardViewController: GeneralItemHandlingDelegate {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    model.saveProviderProfession { [weak self] status in
      if status != ResponseStatus.success.rawValue {
        self?.showWarningAlert(message: status)
        return
      }
      
      DispatchQueue.main.async {
        self?.back()
      }
    }
  }
}
