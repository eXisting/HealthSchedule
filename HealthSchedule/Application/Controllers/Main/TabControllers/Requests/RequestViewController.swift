//
//  HistoryViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CoreData
import Presentr

class RequestViewController: UIViewController {
  private let titleName = "Requests"
  
  private let mainView = RequestsView()
  private let model = RequestsModel()
  
  private lazy var presenter: Presentr = {
    let customType = PresentationType.custom(
      width: .fluid(percentage: 0.8),
      height: .fluid(percentage: 0.6),
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
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DataBaseManager.shared.setFrcDelegate(for: .request, delegate: self)
    
    model.errorHandling = self
    
    mainView.setup(delegate: self, dataSource: model.dataSource, refreshDelegate: self)
    
    setupNavigationItem()
  }
  
  private func setupNavigationItem() {
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationItem.title = titleName
  }
  
  private func onRequestsLoaded(response: String) {
    if response != ResponseStatus.success.rawValue {
      showWarningAlert(message: response)
    }
  }
  
  private func onInnerActionButtonCallback() {
    dismiss(animated: true)
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

extension RequestViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height * 0.1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = RequestCardViewController(DataBaseManager.shared.requestsResultController.object(at: indexPath), onInnerActionButtonCallback)
    customPresentViewController(presenter, viewController: controller, animated: true)
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    let request = DataBaseManager.shared.requestsResultController.object(at: indexPath)
    
    let status = request.status2RequestStatusName()
    
    return (status == .rejected || status == .done) ? UITableViewCell.EditingStyle.delete : .none
  }
}

extension RequestViewController: RefreshingTableView {
  func refresh(_ completion: @escaping (String) -> Void) {
    model.loadRequests { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.showWarningAlert(message: response)
        }
      }
      
      completion(response)
    }
  }
}

extension RequestViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    AlertHandler.ShowAlert(for: self, "Warning", message, .alert)
  }
}

extension RequestViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    mainView.tableView.beginUpdates()
  }
  
  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?) {
    
    switch (type) {
    case .insert:
      if let indexPath = newIndexPath {
        mainView.tableView.insertRows(at: [indexPath], with: .fade)
      }
      break;
    case .delete:
      if let indexPath = indexPath {
        mainView.tableView.deleteRows(at: [indexPath], with: .fade)
      }
      break;
    case .update:
      if let indexPath = indexPath {
        guard let cell = mainView.tableView.cellForRow(at: indexPath) as? RequestListRow,
          let requestObject = anObject as? Request else { return }
        
        cell.populateCell(
          serviceName: requestObject.service?.name ?? "Unkown name",
          price: String(requestObject.providerService?.price ?? 0.0),
          visitedDate: DateManager.shared.dateToString(requestObject.requestedAt),
          status: requestObject.status2RequestStatusName()
        )
      }
      break;
      
    case .move:
      if let indexPath = indexPath {
        mainView.tableView.deleteRows(at: [indexPath], with: .fade)
      }
      
      if let newIndexPath = newIndexPath {
        mainView.tableView.insertRows(at: [newIndexPath], with: .fade)
      }
      break;
      
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    mainView.tableView.endUpdates()
  }
}
