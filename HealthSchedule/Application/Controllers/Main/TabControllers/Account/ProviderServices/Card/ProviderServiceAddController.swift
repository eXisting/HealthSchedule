//
//  ProviderServiceAddController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServiceCardController: UIViewController {
  private let titleName = "Add new service"
  
  private var model: ProviderServiceModel!
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
  
  convenience init(service: ProviderService?) {
    self.init()
    model = ProviderServiceModel(service: service)
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
  
  private func presentServicePicker(with identifier: IndexPath) {
//    model.getServices {
//      [weak self] cities in
//      DispatchQueue.main.async {
//        let controller = ModalCityViewController()
//        controller.storeDelegate = self
//        controller.cititesList = cities
//        self!.model.presentedIdetifier = identifier
//        self!.customPresentViewController(self!.presenter, viewController: controller, animated: true)
//      }
//    }
  }
  
  private func presentDurationPicker(with identifier: IndexPath) {
    
  }
}

extension ProviderServiceCardController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return model[indexPath.section][indexPath.row].rowHeight
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return model[section].sectionHeight
  }
}

extension ProviderServiceCardController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    guard let identifyingTextField = textField as? IdentifyingTextField else {
        return true
    }
    
    switch identifyingTextField.subType {
    case .datePicker:
      (textField as? IdentifyingTextField)?.aciton?()
      return true
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

extension ProviderServiceCardController: ProviderServiceHandling {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    model.postService { status in
      if status == ResponseStatus.success.rawValue {
        // TODO
      }
      
      print(status)
    }
  }
}
