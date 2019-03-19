//
//  AccountViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol AccountHandlableDelegate {
  func logout()
  func save()
}

class AccountViewController: UIViewController, SetupableTabBarItem {
  private let titleName = "Account"
  
  private let mainView = ProfileView()
  private let model = AccountModel()
  
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
    model.dataSource.textFieldDelegate = self
    
    mainView.setup(delegate: self, dataSource: model.dataSource)
    mainView.setRefreshDelegate(delegate: self)
  }
  
  func setupTabBarItem() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/account")
    tabBarItem.image = UIImage(named: "TabBarIcons/account")
  }
  
  private func pushController(for disclosureType: AccountRowType) {
    switch disclosureType {
    case .profession:
      navigationController?.pushViewController(UIViewController(), animated: true)
    case .service:
      navigationController?.pushViewController(UIViewController(), animated: true)
    case .address:
      navigationController?.pushViewController(UIViewController(), animated: true)
    case .schedule:
      navigationController?.pushViewController(UIViewController(), animated: true)
    case .password:
      navigationController?.pushViewController(UIViewController(), animated: true)
      
    case .general:
      return
    }
  }
}

extension AccountViewController: AccountHandlableDelegate {
  func logout() {
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

extension AccountViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 55
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let rowData = model.dataSource[indexPath.section][indexPath.row]
    pushController(for: rowData.type)
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
}
