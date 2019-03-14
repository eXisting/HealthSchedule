//
//  AccountViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, SetupableTabBarItem {
  private let titleName = "Account"
  
  private let mainView = ProfileView()
  private let model = AccountModel()
  
  override func loadView() {
    super.loadView()
    
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.setup(delegate: self, dataSource: self)
    model.startLoadImage(from: DataBaseManager.shared.getCurrentUser()?.image?.url, setImageForView)
    
    navigationItem.title = titleName
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
}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 55
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 35
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return model.userData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountTableView.sectionIdentifier) as! CommonSection
    
    guard let tuple = model.userData?[section] else {
      return header
    }

    header.setup(title: tuple.sectionName, backgroundColor: CommonSection.lightSectionColor)
    
    return header
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableView.cellIdentifier, for: indexPath) as! AccountRow
    
    guard let tuple = model.userData?[indexPath.section] else {
      return cell
    }

    cell.value = tuple.rowValue
    
    return cell
  }
}
