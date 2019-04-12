//
//  FeedViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol SearchPickResponsible {
  func pickHandler(from optionControllerWithKey: SearchOptionKey, data: Any)
}

protocol SearchResponsible {
  func startSearch()
}

class SearchViewController: UIViewController {
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
    mainView.setup(delegate: self, dataSource: self, searchDelegate: self)
    setupNavigationItem()
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
      guard let data = data as? Int else {
        showWarningAlert(message: "Contact the developer!")
        return
      }
      
      model.serviceId = data
    }
    
    navigationController?.popViewController(animated: true)
  }
}

extension SearchViewController: SearchResponsible {
  func startSearch() {
//    let searchData = model.getSearchOptions()
//    if let warningMessage = searchData.errorMessage {
//      showWarningAlert(message: warningMessage)
//      return
//    }
    
    model.startSearch()
    
    // TODO: Load
    
    navigationController?.present(ResultViewController(), animated: true)
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
    pushController(with: model.searchOptions[indexPath.row])
  }
}

extension SearchViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    AlertHandler.ShowAlert(
      for: self,
      "Warning",
      message,
      .alert)
  }
}
