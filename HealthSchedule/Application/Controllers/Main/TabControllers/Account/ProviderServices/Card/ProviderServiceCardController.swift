//
//  ProviderServiceAddController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import Presentr
import NVActivityIndicatorView

class ProviderServiceCardController: UIViewController, NVActivityIndicatorViewable {
  private let titleName = "Add new service"
  
  private var model: ProviderServiceModel!
  private let mainView = ProviderServiceGeneralTableView()

  private var customNavigationItem: GeneralActionSaveNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = GeneralActionSaveNavigationItem(title: titleName, delegate: self, type: .save)
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
    
    model.instantiateData()
    hideKeyboardWhenTappedAround()
  }
  
  private func presentServicePicker(with identifier: IndexPath) {
    model.loadServices {
      [weak self] services in
      DispatchQueue.main.async {
        let controller = ModalServicesViewController()
        controller.storeDelegate = self
        controller.list = services
        self!.model.serviceIdentifier = identifier
        self!.customPresentViewController(self!.mainView.presenter, viewController: controller, animated: true)
      }
    }
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

extension ProviderServiceCardController: ModalPickHandling {
  func picked(id: Int, title: String, _ type: ModalPickType = .service) {
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
    case .cityPicker, .professionPicker, .none:
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
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}


extension ProviderServiceCardController: GeneralItemHandlingDelegate {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    showLoader()
    
    model.postService { [weak self] status in
      DispatchQueue.main.async {
        self?.stopAnimating()
      }
      
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
