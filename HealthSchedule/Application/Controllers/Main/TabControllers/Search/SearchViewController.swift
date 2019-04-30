//
//  FeedViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

protocol SearchPickResponsible {
  func pickHandler(from optionControllerWithKey: SearchOptionKey, data: Any)
}

protocol SearchResponsible {
  func startSearch()
}

class SearchViewController: UIViewController, NVActivityIndicatorViewable {
  private let titleName = "Booking"
  
  private let mainView = SearchView()
  private let model = SearchModel()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(delegate: self, dataSource: self.model.dataSource, searchDelegate: self)
    model.delegate = self
    setupNavigationItem()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    stopAnimating()
  }
  
  private func setupNavigationItem() {
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationItem.title = titleName
  }
  
  private func pushController(with optionKey: SearchOptionKey) {
    switch optionKey {
    case .service:
      let controller = ServicesViewController()
      controller.delegate = self
      navigationController?.pushViewController(controller, animated: true)
    case .dateTime:
      let controller = TimetableViewController()
      controller.delegate = self
      navigationController?.pushViewController(controller, animated: true)
    }
  }
}

extension SearchViewController: SearchPickResponsible {
  func pickHandler(from optionControllerWithKey: SearchOptionKey, data: Any) {
    switch optionControllerWithKey {
    case .dateTime:
      guard let data = data as? TimetableView.DateTimeInterval else {
        showWarningAlert(message: "Contact the developer!")
        return
      }
      
      model.dateTimeInterval = data
    case .service:
      guard let data = data as? (serviceId: Int, cityId: Int) else {
        showWarningAlert(message: "Contact the developer!")
        return
      }
      
      model.serviceId = data.serviceId
      model.cityId = data.cityId
    }
    
    navigationController?.popViewController(animated: true)
  }
}

extension SearchViewController: SearchResponsible {
  func startSearch() {
    if let error = model.validateSearchOptions() {
      showWarningAlert(message: error)
      return
    }
    
    startAnimating(
      CGSize(width: view.frame.width / 2, height: view.frame.height * 0.25),
      message: "Searching...",
      type: NVActivityIndicatorType.orbit,
      color: .white,
      padding: 16
    )
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: { [weak self] in
      if self!.isAnimating {
        self?.stopAnimating()
      }
    })
    
    model.startSearch { [weak self] data in
      self?.stopAnimating()
      
      guard let data = data else {
        self?.showWarningAlert(message: "Something wrong with request. Try again later")
        return
      }
      
      if data.isResponseEmpty() {
        DispatchQueue.main.async {
          CDAlertView(title: "Sorry...", message: "There are no bookings available", type: .custom(image: UIImage(named:"Icons/sad-smile")!)).show()
        }
        
        return
      }
      
      DispatchQueue.main.async {
        self?.navigationController?.present(ResultViewController(data: data, serviceId: self!.model.serviceId!), animated: true)
      }
    }
  }
}

extension SearchViewController: SetupableTabBarItem {
  func setupTabBarItem() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/search")
    tabBarItem.image = UIImage(named: "TabBarIcons/search")
  }
}

extension SearchViewController: TableViewSectionsReloading {
  func reloadSections(_ path: IndexSet, with animation: UITableView.RowAnimation) {
    mainView.reloadSections(path, animation)
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height * 0.1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == SearchDataSource.SectionsIndexes.searchOptions.rawValue {
      pushController(with: model.dataSource.sectionsData[indexPath.section][indexPath.row] as! SearchOptionKey)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return indexPath.section == SearchDataSource.SectionsIndexes.chosenOptions.rawValue ? .delete : .none
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == SearchDataSource.SectionsIndexes.chosenOptions.rawValue ? 30 : 10
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
}

extension SearchViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}
