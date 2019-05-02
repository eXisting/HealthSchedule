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
import CDAlertView
import NVActivityIndicatorView

class RequestViewController: UIViewController, NVActivityIndicatorViewable {
  private let titleName = "Requests"
  
  private let mainView = RequestsView()
  private var model: RequestsModel!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    model = RequestsModel(errorDelegate: self, loaderDelegate: self)
    
    DataBaseManager.shared.setFrcDelegate(for: .request, delegate: self)
    
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
      DispatchQueue.main.async {
        self.showWarningAlert(message: response)
      }
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

extension RequestViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height * 0.1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = RequestCardViewController(DataBaseManager.shared.requestsResultController.object(at: indexPath))
    customPresentViewController(mainView.presenter, viewController: controller, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
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

extension RequestViewController: LoaderShowable {
  func showLoader() {
    startAnimating(
      CGSize(width: view.frame.width / 2, height: view.frame.height * 0.25),
      message: "Refreshing...",
      type: .ballPulse,
      color: .white,
      padding: 16
    )
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: { [weak self] in
      if self!.isAnimating {
        self?.stopAnimating()
      }
    })
  }
  
  func hideLoader() {
    stopAnimating()
  }
}

extension RequestViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
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
          serviceName: requestObject.providerService?.name ?? requestObject.service?.name ?? "Unkown name",
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
    
    if self.isAnimating {
      stopAnimating()      
    }
  }
}
