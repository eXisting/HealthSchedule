//
//  FeedViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  private let titleName = "Booking"
  
  private var rootNavigation: SearchNavigationController!
  
  private let mainView = SearchView()
  private let model = SearchModel()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    rootNavigation = (navigationController as! SearchNavigationController)
    
    navigationItem.title = titleName
    
    mainView.setup(delegate: self, dataSource: self)
    mainView.toggleViews(isDataPresent: model.searchOptions.count > 0)
  }
}

extension SearchViewController: SetupableTabBarItem {
  func setupTabBarItem() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/search")
    tabBarItem.image = UIImage(named: "TabBarIcons/search")
  }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.searchOptions.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height * 0.1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableView.cellIdentifier, for: indexPath)
    cell.textLabel?.text = model.searchOptions[indexPath.row].rawValue
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    rootNavigation.pushController(for: model.searchOptions[indexPath.row])
  }
}
