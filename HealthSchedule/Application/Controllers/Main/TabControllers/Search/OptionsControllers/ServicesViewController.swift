//
//  ServicesViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController {
  private let titleName = "Services"
  
  private var rootNavigation: SearchNavigationController!
  
  private let model = ServicesModel()
  private let mainView = ServicesSearchView()
  private let searchBar = UISearchBar()
  
  override func loadView() {
    super.loadView()
    
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = searchBar
    
    searchBar.sizeToFit()
    searchBar.placeholder = "Location..."
    searchBar.delegate = self

    mainView.setup(delegate: self, dataSource: self)
    
    rootNavigation = (navigationController as! SearchNavigationController)
    navigationItem.title = titleName
  }
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "")
    return UITableViewCell()
  }
}

extension ServicesViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    rootNavigation.presentResultController()
    return false
  }
}
