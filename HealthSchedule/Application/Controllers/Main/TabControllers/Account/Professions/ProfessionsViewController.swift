//
//  ProfessionsViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CoreData
import CDAlertView

class ProfessionsViewController: UIViewController {
  private let titleName = "Your experience"
  
  private let model = ProviderProfessionsModel()
  private let mainView = ProviderProfessionsView()
  
  private var customNavigationItem: GeneralActionSaveNavigationItem?
  
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
    DataBaseManager.shared.setFrcDelegate(for: .providerProfessions, delegate: self)
    model.prefetch()
    
    mainView.setup(delegate: self, dataSource: model.dataSource)
    mainView.refreshDelegate = self
    
    setupNavigationBarAppearance()
  }
  
  private func setupNavigationBarAppearance() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.backgroundColor = .gray
  }
}

extension ProfessionsViewController: RefreshingTableView {
  func refresh(_ completion: @escaping (String) -> Void) {
    model.loadProviderProfessions { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        self?.showWarningAlert(message: response)
      }
      
      completion(response)
    }
  }
}

extension ProfessionsViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension ProfessionsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let providerProfession = DataBaseManager.shared.providerProfessionFrc.object(at: indexPath)
    navigationController?.pushViewController(ProviderProfessionCardViewController(profession: providerProfession), animated: true)
  }
}

extension ProfessionsViewController: NSFetchedResultsControllerDelegate {
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
        guard let cell = mainView.cellForRow(at: indexPath) as? ProviderProfessionViewCell,
          let providerProfession = anObject as? ProviderProfession else { return }
        
        cell.setupData(id: Int(providerProfession.id), city: providerProfession.city!.name!, company: providerProfession.companyName!)
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

extension ProfessionsViewController: GeneralItemHandlingDelegate {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    navigationController?.pushViewController(ProviderProfessionCardViewController(profession: nil), animated: true)
  }
}
