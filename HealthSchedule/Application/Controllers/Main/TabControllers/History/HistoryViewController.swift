//
//  HistoryViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
  private let titleName = "History"
  
  private let mainView = HistoryView()
  private let model = UserMainModel()
    
  override func loadView() {
    super.loadView()
    
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.setup(delegate: self, dataSource: self)
//    TODO: Get all completed requests
    model.getProfessions() {
      [weak self] result in
      DispatchQueue.main.async {
        self?.mainView.toggleViews(isDataPresent: true)
      }
    }
  }
}

// MARK: -Extensions

extension HistoryViewController: SetupableTabBarItem {
  func setupTabBarItem() {
    tabBarItem.title  = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/history")
    tabBarItem.image = UIImage(named: "TabBarIcons/history")
  }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryTableView.sectionIdentifier) as! CommonSection
    header.setup(title: "John Smith", backgroundColor: UIColor.blue.withAlphaComponent(0.1))
    return header
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableView.cellIdentifier) as! HistoryRow
    cell.populateCell(serviceName: "Super mega service", price: "$99.99", visitedDate: "12.02.2019")
    return cell
  }
}
