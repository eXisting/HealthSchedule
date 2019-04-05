//
//  FetchResultControllersComposer.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import CoreData

enum FrcDelegateType {
  case request
  case providerService
}

class FetchResultControllersComposer {
  private weak var requestsFrcDelegate: NSFetchedResultsControllerDelegate?
  private weak var providerServicesFrcDelegate: NSFetchedResultsControllerDelegate?
  
  lazy var requestsFetchResultController: NSFetchedResultsController<Request> = {
    let fetchRequest: NSFetchRequest<Request> = Request.fetchRequest()
    
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: "status", ascending: false),
      NSSortDescriptor(key: "requestedAt", ascending: true)
    ]
    
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.relationshipKeyPathsForPrefetching = ["providerService", "service"]
    fetchRequest.fetchBatchSize = 20
    
    let controller = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: DataBaseManager.shared.mainContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    controller.delegate = requestsFrcDelegate
    
    do {
      let _ = try controller.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return controller
  }()
  
  lazy var providerServicesFetchResultController: NSFetchedResultsController<ProviderService> = {
    let fetchRequest: NSFetchRequest<ProviderService> = ProviderService.fetchRequest()
    
//    let secondarySortDescriptor = NSSortDescriptor(key: "service.name", ascending: true)
    let primarySortDescriptor = NSSortDescriptor(key: "id", ascending: true)

    fetchRequest.sortDescriptors = [
//      secondarySortDescriptor,
      primarySortDescriptor
    ]
    
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.relationshipKeyPathsForPrefetching = ["service"]//, "address"]
    fetchRequest.fetchBatchSize = 20
    
    let controller = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: DataBaseManager.shared.mainContext,
      sectionNameKeyPath: nil,//"service.name",
      cacheName: nil)
    
    controller.delegate = providerServicesFrcDelegate
    
    do {
      let _ = try controller.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return controller
  }()
  
  func setDelegate(for frcType: FrcDelegateType, delegate: NSFetchedResultsControllerDelegate?) {
    switch frcType {
    case .providerService:
      providerServicesFrcDelegate = delegate
    case .request:
      requestsFrcDelegate = delegate
    }
  }
}
