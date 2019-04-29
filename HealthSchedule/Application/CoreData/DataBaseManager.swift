//
//  DataBaseManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import Foundation
import CoreData

class DataBaseManager: NSObject {
  
  // MARK: Singleton
  
  static let shared = DataBaseManager()
  private override init() {}
  
  // MARK: Fields
  
  private let modelName = "MainCoreDataContainer"
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: modelName)
    
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent("\(self.modelName).sqlite")
    
    do {
      let options = [
        NSMigratePersistentStoresAutomaticallyOption : true,
        NSInferMappingModelAutomaticallyOption : true
      ]
      
      try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                        configurationName: nil,
                                                        at: persistentStoreURL,
                                                        options: options)
      
    } catch {
      fatalError("Unable to Add Persistent Store")
    }
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
      
      container.viewContext.automaticallyMergesChangesFromParent = true
    })
    
    return container
  }()
  
  private lazy var executer: CoreDataRequestsBase = {
    return CoreDataRequestsBase(provider: self)
  }()
  
  var fetchRequestsHandler: FetchRequestsHandler {
    return executer.fetchRequestsHandler
  }
  
  // MARK: - Fetch result controller composer
  
  private lazy var frcComposer = {
    return FetchResultControllersComposer()
  }()
  
  var requestsResultController: NSFetchedResultsController<Request> {
    return frcComposer.requestsFetchResultController
  }
  
  var providerServicesFrc: NSFetchedResultsController<ProviderService> {
    return frcComposer.providerServicesFetchResultController
  }
  
  var providerProfessionFrc: NSFetchedResultsController<ProviderProfession> {
    return frcComposer.providerProfessionsFetchResultController
  }
  
  func setFrcDelegate(for frcType: FrcDelegateType, delegate: NSFetchedResultsControllerDelegate?) {
    frcComposer.setDelegate(for: frcType, delegate: delegate)
  }
  
  // MARK: - Core Data Saving support
  
  func clearUntilCache() {
    executer.deleteAllRecords(context: persistentContainer.viewContext)
  }
  
  func saveData() {
    executer.saveContext(persistentContainer.viewContext)
  }
}

protocol ContextsProviding: class {
  var mainContext: NSManagedObjectContext { get }
  func provideWorkingContext(basedOn passedContext: NSManagedObjectContext?) -> NSManagedObjectContext
}

extension DataBaseManager: ContextsProviding {
  var mainContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func provideWorkingContext(basedOn passedContext: NSManagedObjectContext?) -> NSManagedObjectContext {
    var workingContext : NSManagedObjectContext!
    if passedContext != nil {
      workingContext = passedContext
    } else {
      workingContext = persistentContainer.newBackgroundContext()
    }
    
    workingContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    return workingContext
  }
}


extension DataBaseManager: CoreDataRequestsPerformable {
  func insertUpdateProfessions(from list: [RemoteProfession], context: NSManagedObjectContext? = nil) {
    executer.insertUpdateProfessions(from: list, context: context)
  }
  
  func insertUpdateProviderProfessions(from list: [RemoteProviderProfession], context: NSManagedObjectContext? = nil) {
    executer.insertUpdateProviderProfessions(from: list, context: context)
  }
  
  func insertUpdateScheduleDayTemplate(from days: [RemoteScheduleTemplateDay], context: NSManagedObjectContext? = nil) {
    executer.insertUpdateScheduleDayTemplate(from: days, context: context)
  }
  
  func insertUpdateUserAddress(from remote: RemoteAddress, for userId: Int, context: NSManagedObjectContext? = nil) {
    executer.insertUpdateUserAddress(from: remote, for: userId, context: context)
  }
  
  func insertUpdateUsers(from remoteUsers: [RemoteUser], context: NSManagedObjectContext? = nil) {
    executer.insertUpdateUsers(from: remoteUsers, context: context)
  }
  
  func insertUpdateUserImage(from remote: ProfileImage, for user: User, context: NSManagedObjectContext? = nil) {
    executer.insertUpdateUserImage(from: remote, for: user, context: context)
  }
  
  func insertUpdateCities(from cityList: [RemoteCity], context: NSManagedObjectContext? = nil) {
    executer.insertUpdateCities(from: cityList, context: context)
  }
  
  func insertUpdateServices(from serviceList: [RemoteService], context: NSManagedObjectContext? = nil) {
    executer.insertUpdateServices(from: serviceList, context: context)
  }
  
  func insertUpdateProviderServices(from list: [RemoteProviderService], context: NSManagedObjectContext? = nil) {
    executer.insertUpdateProviderServices(from: list, context: context)
  }
  
  func insertUpdateRequests(from requestList: [RemoteRequest], context: NSManagedObjectContext? = nil) {
    executer.insertUpdateRequests(from: requestList, context: context)
  }
  
  func delete(with id: NSManagedObjectID, context: NSManagedObjectContext? = nil) {
    executer.delete(with: id, context: context)
  }
}
