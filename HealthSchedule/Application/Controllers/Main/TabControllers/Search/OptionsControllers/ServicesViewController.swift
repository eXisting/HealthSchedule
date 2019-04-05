//
//  ServicesViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr
import UIEmptyState

class ServicesViewController: UITableViewController {
  private let titleName = "Services"
  
  private var parentNavigationController: SearchNavigationController!
  
  private let presenter: Presentr = {
    let customType = PresentationType.popup
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .coverVerticalFromTop
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    return customPresenter
  }()
  
  private let model = ServicesModel()
  private let searchBar = UISearchBar()
  
  override func loadView() {
    super.loadView()
    navigationItem.titleView = searchBar
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTopBar()
    
    self.emptyStateDataSource = self
    self.emptyStateDelegate = self
    
    parentNavigationController = (navigationController as! SearchNavigationController)
    
    // Remove seperator lines from empty cells
    self.tableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.reloadEmptyState()
  }
  
  private func setupTopBar() {
    searchBar.sizeToFit()
    searchBar.placeholder = "Location..."
    searchBar.delegate = self
    
    navigationItem.title = titleName
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.services.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = model.services[indexPath.row].title
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    model.serviceId = model.services[indexPath.row].id
    parentNavigationController.popFromService(model.serviceId!)
  }
}

extension ServicesViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    model.getCities {
      [weak self] cities in
      DispatchQueue.main.async {
        let controller = ModalCityViewController()
        controller.storeDelegate = self
        controller.cititesList = cities
        self!.customPresentViewController(self!.presenter, viewController: controller, animated: true)
      }
    }
    
    // TODO: Present preloader
    
    return false
  }
}

extension ServicesViewController: ModalPickHandling {
  func picked(id: Int, title: String) {
    model.cityId = id
    searchBar.text = title
    model.startLoadServices {
      [weak self] in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
        self?.reloadEmptyState()
      }
    }
  }
}

extension ServicesViewController: UIEmptyStateDataSource, UIEmptyStateDelegate {
  // MARK: - Empty State Data Source
  
  var emptyStateImage: UIImage? {
    return UIImage(named: "Pictures/services")
  }
  
  var emptyStateTitle: NSAttributedString {
    let attrs = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.882, green: 0.890, blue: 0.859, alpha: 1.00),
                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
    return NSAttributedString(string: "Nothing here!", attributes: attrs)
  }
}
