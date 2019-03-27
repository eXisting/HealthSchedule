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
  
  private let userEntity = "User"
  private let userImageEntity = "UserImage"
  private let cityEntity = "City"
  private let serviceEntity = "Service"
  private let requestEntity = "Request"
  private let providerServiceEntity = "ProviderService"
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MainCoreDataContainer")
    
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent("\(self.modelName).sqlite")
    
    do {
      let options = [
        NSMigratePersistentStoresAutomaticallyOption : true,
        NSInferMappingModelAutomaticallyOption : true
      ]
      
      // Add Persistent Store
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
    return FetchRequestsHandler(container: persistentContainer)
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
  
  lazy var resultController: NSFetchedResultsController<Request> = {
    let fetchRequest: NSFetchRequest<Request> = Request.fetchRequest()
    
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: "status", ascending: true),
      NSSortDescriptor(key: "requestedAt", ascending: true)
    ]
    
    fetchRequest.returnsObjectsAsFaults = false
    //    fetchRequest.relationshipKeyPathsForPrefetching = ["department"]
    fetchRequest.fetchBatchSize = 20
    
    let controller = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: persistentContainer.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      let _ = try controller.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return controller
  }()
  
  // MARK: Actions
  
  func insertUpdateUsers(from remoteUsers: [RemoteUser]) {
    let backgroundContext = persistentContainer.newBackgroundContext()
    
    let userEntityObject = NSEntityDescription.entity(forEntityName: userEntity, in: backgroundContext)
    
    for remoteUser in remoteUsers {
      let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteUser.id))")
      
      do {
        let result = try backgroundContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.buildBasicUserFields(for: result.first!, remoteUser)
        }
        // Insert
        else {
          let user = NSManagedObject(entity: userEntityObject!, insertInto: backgroundContext) as! User
          
          builder.buildBasicUserFields(for: user, remoteUser)
          
          if let remoteImage = remoteUser.photo {
            let photoEntity = NSEntityDescription.entity(forEntityName: userImageEntity, in: backgroundContext)
            let userImage = NSManagedObject(entity: photoEntity!, insertInto: backgroundContext) as! UserImage
            
            builder.buildBasicFields(for: userImage, with: user.id, remoteImage)
            
            user.image = userImage
            userImage.user = user
          }
          
          if let remoteCity = remoteUser.city {
            let userCityEntity = NSEntityDescription.entity(forEntityName: cityEntity, in: backgroundContext)
            let userCity = NSManagedObject(entity: userCityEntity!, insertInto: backgroundContext) as! City
            
            builder.build(city: userCity, remoteCity)
            
            userCity.addToUser(user)
            user.city = userCity
          }
          
          backgroundContext.insert(user)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    backgroundContext.processPendingChanges()
    saveContext(backgroundContext)
  }
  
  func insertUpdateCities(from cityList: [RemoteCity]) {
    let backgroundContext = persistentContainer.newBackgroundContext()
    let cityEntityObject = NSEntityDescription.entity(forEntityName: cityEntity, in: backgroundContext)
    
    for remoteCity in cityList {
      let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteCity.id))")
      
      do {
        let result = try backgroundContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          result.first?.name = remoteCity.title
        }
        // Insert
        else {
          let city = NSManagedObject(entity: cityEntityObject!, insertInto: backgroundContext) as! City
          builder.build(city: city, remoteCity)
          backgroundContext.insert(city)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    backgroundContext.processPendingChanges()
    saveContext(backgroundContext)
  }
  
  func insertUpdateServices(from serviceList: [RemoteService]) {
    let backgroundContext = persistentContainer.newBackgroundContext()
    let serviceEntityObject = NSEntityDescription.entity(forEntityName: serviceEntity, in: backgroundContext)
    
    for remoteService in serviceList {
      let fetchRequest: NSFetchRequest<Service> = Service.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteService.id))")
      
      do {
        let result = try backgroundContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(service: result.first!, remoteService)
        }
          // Insert
        else {
          let service = NSManagedObject(entity: serviceEntityObject!, insertInto: backgroundContext) as! Service
          builder.build(service: service, remoteService)
          backgroundContext.insert(service)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    backgroundContext.processPendingChanges()
    saveContext(backgroundContext)
  }
  
  func insertUpdateProviderServices(from list: [RemoteProviderService]) {
    let backgroundContext = persistentContainer.newBackgroundContext()
    let providerServiceEntityObject = NSEntityDescription.entity(forEntityName: providerServiceEntity, in: backgroundContext)
    
    for service in list {
      let fetchRequest: NSFetchRequest<ProviderService> = ProviderService.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(service.id))")
      
      do {
        let result = try backgroundContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(providerService: result.first!, service, context: backgroundContext)
        }
        // Insert
        else {
          let providerService = NSManagedObject(entity: providerServiceEntityObject!, insertInto: backgroundContext) as! ProviderService
          builder.build(providerService: providerService, service, context: backgroundContext)
          backgroundContext.insert(providerService)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    backgroundContext.processPendingChanges()
    saveContext(backgroundContext)
  }
  
  func insertUpdateRequests(from requestList: [RemoteRequest]) {
    let backgroundContext = persistentContainer.newBackgroundContext()
    let requestEntityObject = NSEntityDescription.entity(forEntityName: requestEntity, in: backgroundContext)
    backgroundContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    
    for remoteRequest in requestList {
      let fetchRequest: NSFetchRequest<Request> = Request.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteRequest.id))")
      
      do {
        let result = try backgroundContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(request: result.first!, remoteRequest, context: backgroundContext)
        }
        // Insert
        else {
          let request = NSManagedObject(entity: requestEntityObject!, insertInto: backgroundContext) as! Request
          insertUpdateServices(from: [remoteRequest.providerService.service])
          insertUpdateProviderServices(from: [remoteRequest.providerService])
          builder.build(request: request, remoteRequest, context: backgroundContext)
          backgroundContext.insert(request)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    backgroundContext.processPendingChanges()
    saveContext(backgroundContext)
  }
}
