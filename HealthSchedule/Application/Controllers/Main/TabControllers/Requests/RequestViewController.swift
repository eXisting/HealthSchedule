//
//  HistoryViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr

class RequestViewController: UIViewController {
  private let titleName = "Requests"
  
  private let mainView = RequestListTableView()
  private let model = RequestsModel()
  
  private lazy var presenter: Presentr = {
    let customType = PresentationType.custom(
      width: .fluid(percentage: 0.8),
      height: .fluid(percentage: 0.5),
      center: .center
    )
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .crossDissolve
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    customPresenter.cornerRadius = 10
    return customPresenter
  }()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.setup(delegate: self, dataSource: self)
    mainView.refreshDelegate = self
    
    model.loadRequests(onRequestsLoaded)
  }
  
  private func onRequestsLoaded() {
    DispatchQueue.main.async {
      self.mainView.reloadData()
    }
  }
}

// MARK: -Extensions

extension RequestViewController: SetupableTabBarItem {
  func setupTabBarItem() {
    tabBarItem.title  = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/requests")
    tabBarItem.image = UIImage(named: "TabBarIcons/requests")
  }
}

extension RequestViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.requests.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height * 0.1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RequestListTableView.cellIdentifier, for: indexPath) as! RequestListRow
    let request = model.requests[indexPath.row]
    
    cell.populateCell(
      serviceName: request.providerService.service.title,
      price: String(request.providerService.price),
      visitedDate: DateManager.shared.dateToString(request.requestAt),
      status: request.status.title
    )
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = RequestCardViewController()
    controller.set(model.requests[indexPath.row])
    customPresentViewController(presenter, viewController: controller, animated: true)
  }
}

extension RequestViewController: RefreshingTableView {
  func refresh(_ completion: @escaping (String) -> Void) {
    model.loadRequests {
      completion(ResponseStatus.success.rawValue)
    }
  }
}
