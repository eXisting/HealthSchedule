//
//  AccountViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr
import CDAlertView
import NVActivityIndicatorView

protocol AccountHandlableDelegate: class {
  func logout()
  func save()
  func set(image: UIImage)
}

class AccountViewController: UIViewController, NVActivityIndicatorViewable {
  private let titleName = "Account"
  
  private let mainView = ProfileView()
  private var model: AccountModel!
  
  private var customNavigationItem: AccountNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = AccountNavigationItem(title: titleName, delegate: self)
      }
      
      return customNavigationItem!
    }
  }
  
  private let imagePickerController = ImagePickerController()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    model = AccountModel(accountHandlingDelegate: self, textFieldDelegate: self)
    
    mainView.setup(delegate: self, dataSource: model.dataSource, imagePickerDelegate: self)
    mainView.setRefreshDelegate(delegate: self)
    
    hideKeyboardWhenTappedAround()
  }
  
  private func pushController(for disclosureType: AccountRowType) {
    switch disclosureType {
    case .profession:
      navigationController?.pushViewController(ProfessionsViewController(), animated: true)
    case .service:
      navigationController?.pushViewController(ProviderServicesController(), animated: true)
    case .address:
      navigationController?.pushViewController(AddressViewController(), animated: true)
    case .schedule:
      let story = UIStoryboard.init(name: "JZCalendar", bundle: nil)
      guard let viewController = story.instantiateInitialViewController() else {
        fatalError("Initial view controller has not been set!")
      }
      navigationController?.pushViewController(viewController, animated: true)
    case .password:
      navigationController?.pushViewController(PasswordViewController(), animated: true)
    case .general:
      return
    }
  }
  
  private func presentCityPicker(with identifier: IndexPath) {
    model.getCities {
      [weak self] cities in
      DispatchQueue.main.async {
        let controller = ModalCityViewController()
        controller.storeDelegate = self
        controller.cititesList = cities
        self!.model.presentedIdetifier = identifier
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

extension AccountViewController: AccountHandlableDelegate {
  func set(image: UIImage) {
    DispatchQueue.main.async {
      self.mainView.setImage(image)
    }
  }
  
  func logout() {
    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.logutTriggered.rawValue)
    NotificationCenter.default.post(name: .LogoutCalled, object: nil)
  }
  
  func save() {
    showLoader()
    
    model.handleSave { [weak self] response in
      DispatchQueue.main.async {
        self?.stopAnimating()
      }
      
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.showWarningAlert(message: response)
        }
      }
    }
  }
}

extension AccountViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension AccountViewController: SetupableTabBarItem {
  func setupTabBarItem() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/account")
    tabBarItem.image = UIImage(named: "TabBarIcons/account")
  }
}

extension AccountViewController: RefreshingTableView {
  func refresh(_ completion: @escaping (String) -> Void) {
    model.reloadRemoteUser(completion)
  }
}

extension AccountViewController: ModalPickHandling {
  func picked(id: Int, title: String, _ type: ModalPickType = .city) {
    guard let identifier = model.presentedIdetifier else {
      return
    }
    
    model.changeText(by: identifier, with: title)
    model.changeStoredId(by: identifier, newId: id)
    mainView.reloadRows(at: [identifier])
  }
}

extension AccountViewController: ImagePickerDelegate {
  func populateImageView(with image: UIImage?, named: String?) {
    guard let image = image, let name = named else { return }
    
    model.imageName = name
    model.userImageData = image.jpegData(compressionQuality: 1)
    
    mainView.setImage(image)
  }
  
  func presentPicker() {
    if !imagePickerController.isInitialized {
      let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
      startAnimating(size, type: .lineScale, color: .white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
    }
    
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self!.imagePickerController.setup(delegate: self!, with: .photoLibrary)
      
      DispatchQueue.main.async { [weak self] in
        self!.present(self!.imagePickerController.picker, animated: true, completion: { [weak self] in
          if self!.isAnimating {
            self!.stopAnimating()
          }
        })
      }
    }
  }
}

extension AccountViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return model[section].sectionHeight
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let rowData: CommonRowDataContaining = model[indexPath.section][indexPath.row]
    pushController(for: rowData.type)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountTableView.sectionIdentifier) as! CommonSection
    header.setup(title: model[section].sectionName, backgroundColor: CommonSection.lightSectionColor)
    return header
  }
}

extension AccountViewController: UITextFieldDelegate {
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
        identifyingTextField.aciton?()
        return true
      case .cityPicker:
        presentCityPicker(with: identifier)
        return false
      case .servicePicker, .professionPicker, .none:
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
