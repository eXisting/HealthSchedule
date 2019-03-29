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
    
    DataBaseManager.shared.frcDelegate = self
    
    mainView.setup(delegate: self, dataSource: model.dataSource)
    mainView.refreshDelegate = self
    
    model.getStoredRequests(onRequestsLoaded)
  }
  
  private func onRequestsLoaded(response: String) {
    if response != ResponseStatus.success.rawValue {
      showWarningAlert(message: response)
    }
    
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

extension RequestViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height * 0.1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = RequestCardViewController()
    controller.set(DataBaseManager.shared.resultController.object(at: indexPath))
    customPresentViewController(presenter, viewController: controller, animated: true)
  }
}

extension RequestViewController: RefreshingTableView {
  func refresh(_ completion: @escaping (String) -> Void) {
    model.loadRequests(completion)
  }
}

extension RequestViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    AlertHandler.ShowAlert(for: self, "Warning", message, .alert)
  }
}

extension RequestViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    mainView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      if let indexPath = newIndexPath {
        mainView.insertRows(at: [indexPath], with: .fade)
      }
      break;
    case .delete:
      if let indexPath = indexPath {
        mainView.deleteRows(at: [indexPath], with: .fade)
      }
      break;
    case .update:
      if let indexPath = indexPath {
        guard let cell = mainView.cellForRow(at: indexPath) as? RequestListRow,
          let requestObject = anObject as? Request else { return }
        
        cell.populateCell(
          serviceName: requestObject.service?.name ?? "Unkown name",
          price: String(requestObject.providerService?.price ?? 0.0),
          visitedDate: DateManager.shared.dateToString(requestObject.requestedAt),
          status: String(requestObject.status)
        )
      }
      break;
      
    case .move:
      if let indexPath = indexPath {
        mainView.deleteRows(at: [indexPath], with: .fade)
      }
      
      if let newIndexPath = newIndexPath {
        mainView.insertRows(at: [newIndexPath], with: .fade)
      }
      break;
      
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    mainView.endUpdates()
  }
}
