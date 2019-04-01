//
//  CoreDataBaseRequests.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 3/29/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import CoreData

protocol CoreDataRequestsPerformable {
  // Update / insert
  
  func insertUpdateUsers(from remoteUsers: [RemoteUser], context: NSManagedObjectContext?)
  func insertUpdateUserImage(from photo: ProfileImage, context: NSManagedObjectContext?)
  
  func insertUpdateCities(from cityList: [RemoteCity], context: NSManagedObjectContext?)
  
  func insertUpdateServices(from serviceList: [RemoteService], context: NSManagedObjectContext?)
  func insertUpdateProviderServices(from list: [RemoteProviderService], context: NSManagedObjectContext?)
  func insertUpdateRequests(from requestList: [RemoteRequest], context: NSManagedObjectContext?)
  
  // Delete
  
  func delete(with id: NSManagedObjectID, context: NSManagedObjectContext?)
}

class CoreDataRequestsBase: CoreDataRequestsPerformable {
  // MARK: -Fields
  
  var fetchRequestsHandler: FetchRequestsHandler

  private var builder: InternalObjectsBuilder
  private unowned var provider: ContextsProviding
  
  // MARK: -Entities names constants
  
  private let userEntity = "User"
  private let userImageEntity = "UserImage"
  private let cityEntity = "City"
  private let serviceEntity = "Service"
  private let requestEntity = "Request"
  private let providerServiceEntity = "ProviderService"
  
  init(provider: ContextsProviding) {
    self.provider = provider
    fetchRequestsHandler = FetchRequestsHandler(provider: provider)
    builder = InternalObjectsBuilder(handler: fetchRequestsHandler)
  }
  
  // MARK: -Update / insert
  
  func insertUpdateRequests(from requestList: [RemoteRequest], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
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
          insertUpdateServices(from: [remoteRequest.providerService.service], context: workingContext)
          insertUpdateProviderServices(from: [remoteRequest.providerService], context: workingContext)
          
          let request = NSManagedObject(entity: requestEntityObject!, insertInto: workingContext) as! Request
          builder.build(request: request, remoteRequest, context: workingContext)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateCities(from cityList: [RemoteCity], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
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
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateServices(from serviceList: [RemoteService], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
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
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateProviderServices(from list: [RemoteProviderService], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
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
          // Required fields
          
          if let remoteUser = service.provider {
            insertUpdateUsers(from: [remoteUser], context: workingContext)
          }
          
          let providerService = NSManagedObject(entity: providerServiceEntityObject!, insertInto: workingContext) as! ProviderService
          builder.build(providerService: providerService, service, context: workingContext)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateUserImage(from photo: ProfileImage, context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let profileImageEntityObject = NSEntityDescription.entity(forEntityName: userImageEntity, in: workingContext)
    
    let fetchRequest: NSFetchRequest<UserImage> = UserImage.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == \(Int16(photo.id))")
    fetchRequest.fetchLimit = 1
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      
      // Update
      if result.count > 0 {
        builder.build(image: result.first!, with: Int(result.first!.userId), photo, context: workingContext)
      }
        // Insert
      else {
        let userImage = NSManagedObject(entity: profileImageEntityObject!, insertInto: workingContext) as! UserImage
        builder.build(image: userImage, with: photo.userId, photo, context: workingContext)
      }
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateUsers(from remoteUsers: [RemoteUser], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
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
          
          // Required relations
          
          if let remoteCity = remoteUser.city {
            insertUpdateCities(from: [remoteCity], context: workingContext)
          }
          
          let user = NSManagedObject(entity: userEntityObject!, insertInto: workingContext) as! User
          builder.build(user: user, remoteUser, context: workingContext)
          
          // Optional relations
          
          if let remoteImage = remoteUser.photo {
            insertUpdateUserImage(from: remoteImage, context: workingContext)
          }
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  // MARK: -Delete
  
  func delete(with id: NSManagedObjectID, context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let managedObject = workingContext.object(with: id)
    workingContext.delete(managedObject)
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func deleteAllRecords(context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    var fetchRequests: [NSFetchRequest<NSFetchRequestResult>] = [
      Service.fetchRequest(),
      ProviderService.fetchRequest(),
      Role.fetchRequest(),
      Request.fetchRequest()
    ]
    
    if let existingUser = fetchRequestsHandler.getCurrentUser(context: workingContext) {
      let cityRequest: NSFetchRequest<NSFetchRequestResult> = City.fetchRequest()
      cityRequest.predicate = NSPredicate(format: "id != \(existingUser.cityId)")
      
      let usersRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
      usersRequest.predicate = NSPredicate(format: "id != \(existingUser.id)")
      
      if let image = existingUser.image {
        let userImageRequest: NSFetchRequest<NSFetchRequestResult> = UserImage.fetchRequest()
        userImageRequest.predicate = NSPredicate(format: "id != \(image.id)")
        
        fetchRequests.append(userImageRequest)
      }
      
      fetchRequests.append(cityRequest)
      fetchRequests.append(usersRequest)
    }
    
    for deleteRequest in fetchRequests {
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteRequest)
      
      do {
        try workingContext.execute(deleteRequest)
        saveContext(workingContext)
      } catch {
        print ("Error while cleaning Core Data: \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: -Contexts merging using recursive function
  
  func saveContext(_ context: NSManagedObjectContext) {
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
}
