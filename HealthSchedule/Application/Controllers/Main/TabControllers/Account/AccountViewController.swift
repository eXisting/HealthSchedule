//
//  AccountViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr

protocol AccountHandlableDelegate: class {
  func logout()
  func save()
  func loadUserPhoto(imageData: Data)
}

class AccountViewController: UIViewController, SetupableTabBarItem {
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
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    model = AccountModel(accountHandlingDelegate: self)
    
    model.dataSource.textFieldDelegate = self
    
    mainView.setup(delegate: self, dataSource: model.dataSource)
    mainView.setRefreshDelegate(delegate: self)
    
    hideKeyboardWhenTappedAround()
  }
  
  func setupTabBarItem() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/account")
    tabBarItem.image = UIImage(named: "TabBarIcons/account")
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
}

extension AccountViewController: AccountHandlableDelegate {
  func loadUserPhoto(imageData: Data) {
    guard let image = UIImage(data: imageData) else { return }
    
    DispatchQueue.main.async {
      self.mainView.setImage(image)
    }
  }
  
  func logout() {
    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.logutTriggered.rawValue)
    NotificationCenter.default.post(name: .LogoutCalled, object: nil)
  }
  
  func save() {
    model.handleSave()
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

extension AccountViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return model.dataSource[section].sectionHeight
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let rowData: CommonRowDataContaining = model.dataSource[indexPath.section][indexPath.row]
    pushController(for: rowData.type)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountTableView.sectionIdentifier) as! CommonSection
    header.setup(title: model.dataSource[section].sectionName, backgroundColor: CommonSection.lightSectionColor)
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
