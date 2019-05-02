//
//  ProviderServicesController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CoreData
import CDAlertView
import NVActivityIndicatorView

class ProviderServicesController: UIViewController, NVActivityIndicatorViewable {
  private let titleName = "Your services"
  private var customNavigationItem: GeneralActionSaveNavigationItem?
  
  private let mainView = ProviderServicesTableView()
  private var model: ProviderServicesModel!
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = GeneralActionSaveNavigationItem(title: titleName, delegate: self, type: .create)
      }
      
      return customNavigationItem!
    }
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    model = ProviderServicesModel(errorDelegate: self, loaderDelegate: self)
    
    DataBaseManager.shared.setFrcDelegate(for: .providerService, delegate: self)
    
    mainView.setup(delegate: self, dataSource: model.dataSource)
    mainView.refreshDelegate = self
    
    setupNavigationBarAppearance()
  }
  
  private func setupNavigationBarAppearance() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.backgroundColor = .gray
  }
}

extension ProviderServicesController: RefreshingTableView {
  func refresh(_ completion: @escaping (String) -> Void) {
    model.loadServices { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        self?.showWarningAlert(message: response)
      }
      
      completion(response)
    }
  }
}

extension ProviderServicesController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let providerService = DataBaseManager.shared.providerServicesFrc.object(at: indexPath)
    navigationController?.pushViewController(ProviderServiceCardController(service: providerService), animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return UITableViewCell.EditingStyle.delete
  }
}

extension ProviderServicesController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension ProviderServicesController: LoaderShowable {
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

extension ProviderServicesController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    mainView.beginUpdates()
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
        guard let cell = mainView.cellForRow(at: indexPath) as? ProviderServiceCell,
          let providerService = anObject as? ProviderService else { return }
        
        cell.setupData(id: Int(providerService.id), price: providerService.price, duration: providerService.duration)
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

extension ProviderServicesController: GeneralItemHandlingDelegate {
  func back() {    
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    navigationController?.pushViewController(ProviderServiceCardController(service: nil), animated: true)
  }
}
