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
    controller.set(model[indexPath.row])
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
    print("Begin update")
  }
  
  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange sectionInfo: NSFetchedResultsSectionInfo,
    atSectionIndex sectionIndex: Int,
    for type: NSFetchedResultsChangeType) {
//    switch type {
//      case .insert:
//        mainView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//      case .delete:
//        mainView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//      case .move:
//        break
//      case .update:
//        break
//    }
  }
  
  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?) {
//    switch type {
//      case .insert:
//        mainView.insertRows(at: [newIndexPath!], with: .fade)
//      case .delete:
//        mainView.deleteRows(at: [indexPath!], with: .fade)
//      case .update:
//        mainView.reloadRows(at: [indexPath!], with: .fade)
//      case .move:
//        mainView.moveRow(at: indexPath!, to: newIndexPath!)
//    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    mainView.endUpdates()
    print("Ended update")
  }
}
