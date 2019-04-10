//
//  ProviderServiceAddController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr

class ProviderServiceCardController: UIViewController {
  private let titleName = "Add new service"
  
  private var model: ProviderServiceModel!
  private let mainView = ProviderServiceGeneralTableView()

  private var customNavigationItem: ProviderServicesNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = ProviderServicesNavigationItem(title: titleName, delegate: self, type: .save)
      }
      
      return customNavigationItem!
    }
  }
  
  private let presenter: Presentr = {
    let customType = PresentationType.popup
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .crossDissolve
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    return customPresenter
  }()
  
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
    
    model.instantiateData()
  }
  
  private func presentServicePicker(with identifier: IndexPath) {
    model.loadServices {
      [weak self] services in
      DispatchQueue.main.async {
        let controller = ModalServicesViewController()
        controller.storeDelegate = self
        controller.list = services
        self!.model.serviceIdentifier = identifier
        self!.customPresentViewController(self!.presenter, viewController: controller, animated: true)
      }
    }
  }
}

extension ProviderServiceCardController: ModalPickHandling {
  func picked(id: Int, title: String) {
    guard let path = model.serviceIdentifier else { return }
    
    model.setPickedService(for: path, serviceId: id, serviceName: title)
    
    DispatchQueue.main.async {
      self.mainView.reloadRows(at: [path], with: .automatic)
    }
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
    guard let identifyingTextField = textField as? IdentifyingTextField,
      let indexPath = identifyingTextField.identifier else {
        return true
    }
    
    switch identifyingTextField.subType {
    case .datePicker:
      identifyingTextField.aciton?()
      return true
    case .servicePicker:
      presentServicePicker(with: indexPath)
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

extension ProviderServiceCardController: ErrorShowable {
  func showWarningAlert(message: String) {
    AlertHandler.ShowAlert(for: self, "Error", message, .alert)
  }
}


extension ProviderServiceCardController: ProviderServiceHandling {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    model.postService { [weak self] status in
      if status != ResponseStatus.success.rawValue {
        self?.showWarningAlert(message: status)
        return
      }
      
      self?.back()
    }
  }
}
