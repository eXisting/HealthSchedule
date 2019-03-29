//
//  DataBaseManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import Foundation
import CoreData

protocol ContextsProviding: class {
  var mainContext: NSManagedObjectContext { get }
  func provideWorkingContext(basedOn passedContext: NSManagedObjectContext?) -> NSManagedObjectContext
}

class DataBaseManager: NSObject {
  
  // MARK: Singleton
  
  static let shared = DataBaseManager()
  private override init() {}
  
  // MARK: Fields
  
  private let modelName = "MainCoreDataContainer"
  
  private let userEntity = "User"
  private let userImageEntity = "UserImage"
  private let cityEntity = "City"
  private let serviceEntity = "Service"
  private let requestEntity = "Request"
  private let providerServiceEntity = "ProviderService"
  
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
  
  lazy var fetchRequestsHandler: FetchRequestsHandler = {
    return FetchRequestsHandler(provider: self)
  }()
  
  private lazy var builder = {
    return InternalObjectsBuilder(handler: fetchRequestsHandler)
  }()
  
  // MARK: - Core Data Saving support
  
  func clearUntilCache() {
    // TODO: Call it at app start and clear all data except 10-20 records
  }
  
  func saveData() {
    saveContext(persistentContainer.viewContext)
  }
  
  private func saveContext(_ context: NSManagedObjectContext) {
    if !context.hasChanges {
      return
    }
    
    let strongContext = context
    strongContext.performAndWait {
      do {
        try strongContext.save()
      } catch {
        print(error.localizedDescription)
      }
      
      if let parentContext = strongContext.parent {
        parentContext.performAndWait {
          saveContext(parentContext)
        }
      }
    }
  }
  
  // MARK: - Fetch result controller stack
  
  weak var frcDelegate: NSFetchedResultsControllerDelegate?
  
  lazy var resultController: NSFetchedResultsController<Request> = {
    let fetchRequest: NSFetchRequest<Request> = Request.fetchRequest()
    
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: "status", ascending: true),
      NSSortDescriptor(key: "requestedAt", ascending: true)
    ]
    
    fetchRequest.returnsObjectsAsFaults = false
//    fetchRequest.relationshipKeyPathsForPrefetching = ["providerService", "service"]
    fetchRequest.fetchBatchSize = 20
    
    let controller = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: persistentContainer.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    controller.delegate = frcDelegate
    
    do {
      let _ = try controller.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return controller
  }()
  
  // MARK: Actions
  
  func insertUpdateUsers(from remoteUsers: [RemoteUser], context: NSManagedObjectContext? = nil, shouldSave: Bool = true) {
    let workingContext = provideWorkingContext(basedOn: context)
    
    let userEntityObject = NSEntityDescription.entity(forEntityName: userEntity, in: workingContext)
    
    for remoteUser in remoteUsers {
      let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteUser.id))")
      fetchRequest.fetchLimit = 1
      
      do {
        let result = try workingContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(user: result.first!, remoteUser, context: workingContext)
        }
        // Insert
        else {
          if let remoteCity = remoteUser.city {
            insertUpdateCities(from: [remoteCity], context: workingContext)
          }
          
          let user = NSManagedObject(entity: userEntityObject!, insertInto: workingContext) as! User
          builder.build(user: user, remoteUser, context: workingContext)
          
          // TODO: refactor image
          
          if let remoteImage = remoteUser.photo {
            let photoEntity = NSEntityDescription.entity(forEntityName: userImageEntity, in: workingContext)
            let userImage = NSManagedObject(entity: photoEntity!, insertInto: workingContext) as! UserImage
            
            builder.build(image: userImage, with: user.id, remoteImage)
            
            user.image = userImage
            userImage.user = user
          }
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    if shouldSave {
      workingContext.processPendingChanges()
      saveContext(workingContext)
    }
  }
  
  func insertUpdateCities(from cityList: [RemoteCity], context: NSManagedObjectContext? = nil, shouldSave: Bool = true) {
    let workingContext = provideWorkingContext(basedOn: context)
    
    let cityEntityObject = NSEntityDescription.entity(forEntityName: cityEntity, in: workingContext)
    
    for remoteCity in cityList {
      let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteCity.id))")
      fetchRequest.fetchLimit = 1
      
      do {
        let result = try workingContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          result.first?.name = remoteCity.title
        }
        // Insert
        else {
          let city = NSManagedObject(entity: cityEntityObject!, insertInto: workingContext) as! City
          builder.build(city: city, remoteCity)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    if shouldSave {
      workingContext.processPendingChanges()
      saveContext(workingContext)
    }
  }
  
  func insertUpdateServices(from serviceList: [RemoteService], context: NSManagedObjectContext? = nil, shouldSave: Bool = true) {
    let workingContext = provideWorkingContext(basedOn: context)
    
    let serviceEntityObject = NSEntityDescription.entity(forEntityName: serviceEntity, in: workingContext)
    
    for remoteService in serviceList {
      let fetchRequest: NSFetchRequest<Service> = Service.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteService.id))")
      fetchRequest.fetchLimit = 1
      
      do {
        let result = try workingContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(service: result.first!, remoteService)
        }
        // Insert
        else {
          let service = NSManagedObject(entity: serviceEntityObject!, insertInto: workingContext) as! Service
          builder.build(service: service, remoteService)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    if shouldSave {
      workingContext.processPendingChanges()
      saveContext(workingContext)
    }
  }
  
  func insertUpdateProviderServices(from list: [RemoteProviderService], context: NSManagedObjectContext? = nil, shouldSave: Bool = true) {
    let workingContext = provideWorkingContext(basedOn: context)
    
    let providerServiceEntityObject = NSEntityDescription.entity(forEntityName: providerServiceEntity, in: workingContext)
    
    for service in list {
      let fetchRequest: NSFetchRequest<ProviderService> = ProviderService.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(service.id))")
      fetchRequest.fetchLimit = 1
      
      do {
        let result = try workingContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(providerService: result.first!, service, context: workingContext)
        }
        // Insert
        else {
          let providerService = NSManagedObject(entity: providerServiceEntityObject!, insertInto: workingContext) as! ProviderService
          builder.build(providerService: providerService, service, context: workingContext)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    if shouldSave {
      workingContext.processPendingChanges()
      saveContext(workingContext)
    }
  }
  
  func insertUpdateRequests(from requestList: [RemoteRequest], context: NSManagedObjectContext? = nil, shouldSave: Bool = true) {
    let workingContext = provideWorkingContext(basedOn: context)
    
    let requestEntityObject = NSEntityDescription.entity(forEntityName: requestEntity, in: workingContext)
    
    for remoteRequest in requestList {
      let fetchRequest: NSFetchRequest<Request> = Request.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteRequest.id))")
      fetchRequest.fetchLimit = 1
      
      do {
        let result = try workingContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(request: result.first!, remoteRequest, context: workingContext)
        }
        // Insert
        else {
          let request = NSManagedObject(entity: requestEntityObject!, insertInto: workingContext) as! Request
          insertUpdateServices(from: [remoteRequest.providerService.service], context: workingContext, shouldSave: false)
          insertUpdateProviderServices(from: [remoteRequest.providerService], context: workingContext, shouldSave: false)
          
          builder.build(request: request, remoteRequest, context: workingContext)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    if shouldSave {
      workingContext.processPendingChanges()
      saveContext(workingContext)
    }
  }
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
