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
import NVActivityIndicatorView

class ServicesViewController: UITableViewController, NVActivityIndicatorViewable {
  private let titleName = "Services"
  
  private lazy var presenter: Presentr = {
    let customType = PresentationType.popup
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .coverVerticalFromTop
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    customPresenter.cornerRadius = 10
    return customPresenter
  }()
  
  private let model = ServicesModel()
  private let searchBar = UISearchBar()
  
  var delegate: SearchPickResponsible?
  
  override func loadView() {
    super.loadView()
    navigationItem.titleView = searchBar
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTopBar()
    
    self.emptyStateDataSource = self
    self.emptyStateDelegate = self
    
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
    delegate?.pickHandler(from: .service, data: (model.serviceId, model.cityId) as Any)
  }
}

extension ServicesViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      let cities = self!.model.getCities()
      
      DispatchQueue.main.async {
        let controller = ModalCityViewController()
        controller.storeDelegate = self
        controller.cititesList = cities
        self!.customPresentViewController(self!.presenter, viewController: controller, animated: true)
      }
    }
    
    return false
  }
  
  private func showLoader() {
    let size = CGSize(width: view.frame.width / 1.5, height: view.frame.height * 0.35)
    startAnimating(size, message: "Searching services...", type: NVActivityIndicatorType.orbit, color: .white, padding: 16)
  }
}

extension ServicesViewController: ModalPickHandling {
  func picked(id: Int, title: String, _ type: ModalPickType = .service) {
    model.cityId = id
    searchBar.text = title
    
    showLoader()
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: { [weak self] in
      if self != nil && self!.isAnimating {
        self?.stopAnimating()
      }
    })
    
    model.startLoadServices {
      [weak self] in
      DispatchQueue.main.async {
        self?.stopAnimating()

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
