//
//  ProviderServiceAddController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServiceAddController: UIViewController {
  private let titleName = "Add new service"
  
  private let model = CreateProviderServiceModel()
  private let mainView = ProviderCreateTableView()

  private var customNavigationItem: ProviderServicesNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = ProviderServicesNavigationItem(title: titleName, delegate: self, type: .save)
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
    
    model.dataSource.textFieldDelegate = self
    mainView.setup(delegate: self, dataSource: model.dataSource)
    
    model.procceed()
  }
}

extension ProviderServiceAddController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return model[indexPath.section][indexPath.row].rowHeight
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return model[section].sectionHeight
  }
}

extension ProviderServiceAddController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    guard let identifyingTextField = textField as? IdentifyingTextField,
      let identifier = identifyingTextField.identifier else {
        return true
    }
    
    switch identifyingTextField.subType {
    case .datePicker:
      return false
    case .servicePicker:
      return false
    case .cityPicker, .none:
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

extension ProviderServiceAddController: ProviderServiceHandling {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    model.createRequest { status in
      if status == ResponseStatus.success.rawValue {
        // TODO
      }
      
      print(status)
    }
  }
}
