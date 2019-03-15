//
//  ServicesViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr

protocol CityPickHandling {
  func picked(id: Int, title: String)
}

class ServicesViewController: UIViewController {
  private let titleName = "Services"
  
  private var parentNavigationController: SearchNavigationController!
  
  let presenter: Presentr = {
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
  private let mainView = ServicesSearchView()
  private let searchBar = UISearchBar()
  
  override func loadView() {
    super.loadView()    
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTopBar()

    mainView.setup(delegate: self, dataSource: self)
    
    parentNavigationController = (navigationController as! SearchNavigationController)
  }
  
  private func setupTopBar() {
    navigationItem.titleView = searchBar
    
    searchBar.sizeToFit()
    searchBar.placeholder = "Location..."
    searchBar.delegate = self
    
    navigationItem.title = titleName
  }
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.services.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = model.services[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension ServicesViewController: CityPickHandling {
  func picked(id: Int, title: String) {
    model.cityId = id
    searchBar.text = title
    model.startLoadServices {
      [weak self] in
      DispatchQueue.main.async {
        self!.mainView.toggleViews(isDataPresent: self!.model.services.count > 0)
      }
    }
  }
}
