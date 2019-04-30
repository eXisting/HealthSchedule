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
import NVActivityIndicatorView

class ProviderProfessionCardViewController: UIViewController, NVActivityIndicatorViewable {
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
    hideKeyboardWhenTappedAround()
  }
  
  private func presentProfessionsPicker(with identifier: IndexPath) {
    model.getProfessions {
      [weak self] professions in
      if professions.count <= 1 {
        DispatchQueue.main.async {
          self!.showWarningAlert(message: "Cannot get professions list...")
          return
        }
      }
      
      DispatchQueue.main.async {
        let controller = ModalProfessionViewController()
        controller.list = professions
        controller.storeDelegate = self
        self!.model.professionIdentifier = identifier
        self?.customPresentViewController(self!.mainView.presenter, viewController: controller, animated: true)
      }
    }
  }
  
  private func presentCityPicker(with identifier: IndexPath) {
    model.getCities {
      [weak self] cities in
      if cities.count <= 1 {
        DispatchQueue.main.async {
          self!.showWarningAlert(message: "Cannot get cities list...")
          return
        }
      }
      
      DispatchQueue.main.async {
        let controller = ModalCityViewController()
        controller.cititesList = cities
        controller.storeDelegate = self
        self!.model.cityIdentifier = identifier
        self!.customPresentViewController(self!.mainView.presenter, viewController: controller, animated: true)
      }
    }
  }
  
  private func showLoader() {
    let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
    startAnimating(size, type: .ballScaleRipple, color: .white, backgroundColor: UIColor.black.withAlphaComponent(0.75))
  }
}

extension ProviderProfessionCardViewController: ModalPickHandling {
  func picked(id: Int, title: String, _ type: ModalPickType) {
    var path: IndexPath!
    
    switch type {
    case .city:
      guard let cityPath = model.cityIdentifier else { return }
      path = cityPath
      model.setPickedCity(for: path, cityId: id, cityName: title)
    case .profession:
      guard let professionPath = model.professionIdentifier else { return }
      path = professionPath
      model.setPickedProfession(for: path, professionId: id, professionName: title)
    case .service:
      return
    }
    
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
    showLoader()
    
    model.saveProviderProfession { [weak self] status in
      DispatchQueue.main.async {
        self?.stopAnimating()
      }
      
      if status != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.showWarningAlert(message: status)
          return
        }
      }
      
      DispatchQueue.main.async {
        self?.back()
      }
    }
  }
}
