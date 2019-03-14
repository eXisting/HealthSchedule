//
//  AccountViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol AccountHandleDelegating {
  func logout()
  func edit()
  func save()
}

class AccountViewController: UIViewController, SetupableTabBarItem {
  private let titleName = "Account"
  
  private var rootNavigation: AccountNavigationController!
  
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
    
    mainView.setup(delegate: self, dataSource: self)
    model.startLoadImage(from: DataBaseManager.shared.getCurrentUser()?.image?.url, setImageForView)
    
    rootNavigation = (navigationController as! AccountNavigationController)
  }

  private func setImageForView(_ imageData: Data) {
    DispatchQueue.main.async { [weak self] in
      guard let image = UIImage(data: imageData) else {
        return
      }
      
      self?.mainView.setImage(image)
    }
  }
  
  func setupTabBarItem() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/account")
    tabBarItem.image = UIImage(named: "TabBarIcons/account")
  }
  
  func testCallback(_ message: String) {
    print(message)
  }
}

extension AccountViewController: AccountHandleDelegating {
  func logout() {
    NotificationCenter.default.post(name: .TokenDidExpired, object: nil)
  }
  
  func edit() {
    
  }
  
  func save() {
    model.handleSave()
  } 
}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 55
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return model.userData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionName = model.getUserDataKey(by: section)
    
    guard let count = model.userData[sectionName]?.count else {
      return 0
    }
    
    return count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountTableView.sectionIdentifier) as! CommonSection
    
    let sectionName = model.getUserDataKey(by: section)

    header.setup(title: sectionName.rawValue, backgroundColor: sectionName == .none ? .white : CommonSection.lightSectionColor)
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sectionName = model.getUserDataKey(by: indexPath.section)
    guard let tuple = model.userData[sectionName]?[indexPath.row] else {
      fatalError("Cannot get user data for indexPath!")
    }
    
    rootNavigation.pushController(for: model.getClosureType(by: tuple.value))
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let sectionName = model.getUserDataKey(by: indexPath.section)
    guard let tuple = model.userData[sectionName]?[indexPath.row] else {
      fatalError("Cannot get user data for indexPath!")
    }
    
    if tuple.0 != .none {
      guard let placemarkCell = tableView.dequeueReusableCell(
        withIdentifier: AccountTableView.placemarkCellIdentifier,
        for: indexPath) as? AccountPlacemarkCell else {
        fatalError("Cannot cast to AccountPlacemarkCell!")
      }
      
      placemarkCell.value = tuple.value
      placemarkCell.setPlaceholderWithText(tuple.0)
      return placemarkCell
    }
    
    guard let disclosureCell = tableView.dequeueReusableCell(
      withIdentifier: AccountTableView.disclosureCellIdentifier,
      for: indexPath) as? AccountDisclosureCell else {
        fatalError("Cannot cast to AccountDisclosureCell!")
    }
    
    disclosureCell.disclosureType = model.getClosureType(by: tuple.value)
    disclosureCell.value = tuple.value
    
    return disclosureCell
  }
}
