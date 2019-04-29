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

  func insertUpdateUserAddress(from remote: RemoteAddress, for userId: Int, context: NSManagedObjectContext?)

  func insertUpdateUserImage(from remote: ProfileImage, for user: User, context: NSManagedObjectContext?)
  func insertUpdateUsers(from remoteUsers: [RemoteUser], context: NSManagedObjectContext?)

  func insertUpdateScheduleDayTemplate(from days: [RemoteScheduleTemplateDay], context: NSManagedObjectContext?)
  
  func insertUpdateCities(from cityList: [RemoteCity], context: NSManagedObjectContext?)
  
  func insertUpdateProfessions(from list: [RemoteProfession], context: NSManagedObjectContext?)
  func insertUpdateProviderProfessions(from list: [RemoteProviderProfession], context: NSManagedObjectContext?)
  
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
  
  private let addressEntity = "Address"
  private let userEntity = "User"
  private let userImageEntity = "UserImage"
  private let cityEntity = "City"
  private let serviceEntity = "Service"
  private let requestEntity = "Request"
  private let providerServiceEntity = "ProviderService"
  private let providerProfessionEntity = "ProviderProfession"
  private let professionEntity = "Profession"
  private let roleEntity = "Role"
  private let scheduleDayTemplateEntity = "ScheduleDayTemplate"

  init(provider: ContextsProviding) {
    self.provider = provider
    fetchRequestsHandler = FetchRequestsHandler(provider: provider)
    builder = InternalObjectsBuilder(handler: fetchRequestsHandler)
  }
  
  // MARK: -Update / insert
  
  func insertUpdateRequests(from requestList: [RemoteRequest], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    if requestList.isEmpty {
      deleteAllRequests(context: workingContext)
      return
    }
    
    let requestEntityObject = NSEntityDescription.entity(forEntityName: requestEntity, in: workingContext)
    
    for remoteRequest in requestList {
      let fetchRequest: NSFetchRequest<Request> = Request.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteRequest.id))")
      fetchRequest.fetchLimit = 1
      
      // Required fields
      insertUpdateProviderServices(from: [remoteRequest.providerService], context: workingContext)
      
      if let customer = remoteRequest.customer {
        insertUpdateUsers(from: [customer], context: workingContext)
      }
      
      do {
        let result = try workingContext.fetch(fetchRequest)
        
        if !result.isEmpty {
          builder.build(request: result.first!, remoteRequest, context: workingContext)
        } else {
          let object = (NSManagedObject(entity: requestEntityObject!, insertInto: workingContext) as! Request)
          builder.build(request: object, remoteRequest, context: workingContext)
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
      // update
      if let city = fetchRequestsHandler.getCity(byId: remoteCity.id, context: workingContext) {
        city.name = remoteCity.title
        continue
      }
      
      // insert
      let city = NSManagedObject(entity: cityEntityObject!, insertInto: workingContext) as! City
      builder.build(city: city, remoteCity)
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateServices(from serviceList: [RemoteService], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let serviceEntityObject = NSEntityDescription.entity(forEntityName: serviceEntity, in: workingContext)
    
    for remoteService in serviceList {
      // update
      if let service = fetchRequestsHandler.getService(by: remoteService.id, context: workingContext) {
        builder.build(service: service, remoteService, context: workingContext)
        continue
      }
      
      // insert
      let service = NSManagedObject(entity: serviceEntityObject!, insertInto: workingContext) as! Service
      builder.build(service: service, remoteService, context: workingContext)
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateProviderServices(from list: [RemoteProviderService], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let providerServiceEntityObject = NSEntityDescription.entity(forEntityName: providerServiceEntity, in: workingContext)
    
    for remote in list {
      var existingService = fetchRequestsHandler.getProviderService(by: remote.id, context: workingContext)
      
      if existingService == nil {
        existingService = (NSManagedObject(entity: providerServiceEntityObject!, insertInto: workingContext) as! ProviderService)
      }
      
      guard let providerService = existingService else { fatalError() }
      
      builder.build(providerService: providerService, remote, context: workingContext)
      
      if let remoteUser = remote.provider {
        insertUpdateUsers(from: [remoteUser], context: workingContext)
      }
      
      // Required fields
      insertUpdateServiceAddress(from: remote.address, for: providerService, context: workingContext)
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateProviderProfessions(from list: [RemoteProviderProfession], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let professionEntity = NSEntityDescription.entity(forEntityName: providerProfessionEntity, in: workingContext)
    
    for remote in list {
      let fetchRequest: NSFetchRequest<ProviderProfession> = ProviderProfession.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remote.id))")
      fetchRequest.fetchLimit = 1
      
      do {
        let result = try workingContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(providerProfession: result.first!, remote, context: workingContext)
        }
        // Insert
        else {
          let providerProfession = NSManagedObject(entity: professionEntity!, insertInto: workingContext) as! ProviderProfession
          builder.build(providerProfession: providerProfession, remote, context: workingContext)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateProfessions(from list: [RemoteProfession], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let generalProfessionEntity = NSEntityDescription.entity(forEntityName: professionEntity, in: workingContext)
    
    for remote in list {
      // update
      if let profession = fetchRequestsHandler.getProfession(by: remote.id, context: workingContext) {
        builder.build(profession: profession, remote, context: workingContext)
        continue
      }
      
      // insert
      let profession = NSManagedObject(entity: generalProfessionEntity!, insertInto: workingContext) as! Profession
      builder.build(profession: profession, remote, context: workingContext)
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateUserAddress(from remote: RemoteAddress, for userId: Int, context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let userAddressEntity = NSEntityDescription.entity(forEntityName: addressEntity, in: workingContext)
    
    guard let user = fetchRequestsHandler.getCurrentUser(context: workingContext) else { fatalError("Should contain user!") }

    if let existingAddress = user.address {
      delete(with: existingAddress.objectID, context: workingContext)
    }
   
    let address = (NSManagedObject(entity: userAddressEntity!, insertInto: workingContext) as! Address)
    
    builder.build(address: address, attachedUser: user, attachedProviderService: nil, remote, context: workingContext)
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateUserImage(from remote: ProfileImage, for user: User, context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let profileImageEntityObject = NSEntityDescription.entity(forEntityName: userImageEntity, in: workingContext)
    
    if let image = user.image {
      delete(with: image.objectID, context: workingContext)
    }
      
    let userImage = NSManagedObject(entity: profileImageEntityObject!, insertInto: workingContext) as! UserImage
    
    builder.build(image: userImage, for: user, remote, context: workingContext)
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  private func insertUpdateRoles(from remoteRole: RemoteRole, for user: User, context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let roleEntityObject = NSEntityDescription.entity(forEntityName: roleEntity, in: workingContext)
    
    let fetchRequest: NSFetchRequest<Role> = Role.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == \(Int16(remoteRole.id))")
    fetchRequest.fetchLimit = 1
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      
      // Update
      if result.count > 0 {
        builder.build(role: result.first!, attachedUser: user, remoteRole, context: workingContext)
      }
      // Insert
      else {
        let role = NSManagedObject(entity: roleEntityObject!, insertInto: workingContext) as! Role
        builder.build(role: role, attachedUser: user, remoteRole, context: workingContext)
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
      var existingUser = fetchRequestsHandler.getUser(byId: remoteUser.id, context: workingContext)
      
      if existingUser == nil {
        // create
        existingUser = (NSManagedObject(entity: userEntityObject!, insertInto: workingContext) as! User)
      }
      
      guard let user = existingUser else { fatalError() }
      
      // Required relation
      
      if let remoteCity = remoteUser.city {
        insertUpdateCities(from: [remoteCity], context: workingContext)
      }
      
      builder.build(user: user, remoteUser, context: workingContext)
      
      // Optional relations
      
      if let remoteImage = remoteUser.photo {
        insertUpdateUserImage(from: remoteImage, for: user, context: workingContext)
      }
      
      if let remoteRole = remoteUser.role {
        insertUpdateRoles(from: remoteRole, for: user, context: workingContext)
      }
      
      if let remoteAddress = remoteUser.address {
        insertUpdateUserAddress(from: remoteAddress, for: remoteUser.id, context: workingContext)
      }
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func insertUpdateScheduleDayTemplate(from days: [RemoteScheduleTemplateDay], context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let dayEntityObject = NSEntityDescription.entity(forEntityName: scheduleDayTemplateEntity, in: workingContext)
    
    for day in days {
      let fetchRequest: NSFetchRequest<ScheduleDayTemplate> = ScheduleDayTemplate.fetchRequest()
      
      // id new every time so use weekDay to find proper day
      fetchRequest.predicate = NSPredicate(format: "weekDayIndex == \(Int16(day.weekDay))")
      fetchRequest.fetchLimit = 1
      
      guard let currentProvider = fetchRequestsHandler.getCurrentUser(context: workingContext) else {
        fatalError("User must exist here!")
      }
      
      do {
        let result = try workingContext.fetch(fetchRequest)
        
        // Update
        if result.count > 0 {
          builder.build(day: result.first!, day.weekDay, attachedUser: currentProvider, day, context: workingContext)
        }
        // Insert
        else {
          let templateDay = NSManagedObject(entity: dayEntityObject!, insertInto: workingContext) as! ScheduleDayTemplate
          builder.build(day: templateDay, day.weekDay, attachedUser: currentProvider, day, context: workingContext)
        }
      } catch {
        print("Unexpected error: \(error.localizedDescription)")
        abort()
      }
    }
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  // MARK: -Private
  
  private func insertUpdateServiceAddress(from remote: RemoteAddress, for providerService: ProviderService, context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let userAddressEntity = NSEntityDescription.entity(forEntityName: addressEntity, in: workingContext)
    
    var existingAddress = fetchRequestsHandler.getAddress(by: remote.id, context: workingContext)
    
    if existingAddress == nil {
      existingAddress = (NSManagedObject(entity: userAddressEntity!, insertInto: workingContext) as! Address)
    }
    
    guard let address = existingAddress else { fatalError() }
    
    builder.build(address: address, attachedUser: nil, attachedProviderService: providerService, remote, context: workingContext)
  }
  
  // MARK: -Delete
  
  func delete(with id: NSManagedObjectID, context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let managedObject = workingContext.object(with: id)
    workingContext.delete(managedObject)
    
    workingContext.processPendingChanges()
    saveContext(workingContext)
  }
  
  func deleteAllRequests(context: NSManagedObjectContext? = nil) {
    let workingContext = provider.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Request.fetchRequest()
    
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try workingContext.execute(deleteRequest)
      saveContext(workingContext)
    } catch {
      print ("Error while cleaning Core Data: \(error.localizedDescription)")
    }
  }
  
  func deleteAllRecords(context: NSManagedObjectContext? = nil) {
    // TODO: REFACTOR THIS
//    let workingContext = provider.provideWorkingContext(basedOn: context)
//
//    var fetchRequests: [NSFetchRequest<NSFetchRequestResult>] = [
//      Service.fetchRequest(),
//      ProviderService.fetchRequest(),
//      Request.fetchRequest(),
//      ScheduleDayTemplate.fetchRequest()
//    ]
//
//    if let existingUser = fetchRequestsHandler.getCurrentUser(context: workingContext) {
//      let cityRequest: NSFetchRequest<NSFetchRequestResult> = City.fetchRequest()
//      cityRequest.predicate = NSPredicate(format: "id != \(existingUser.cityId)")
//      cityRequest.fetchLimit = 1
//
//      let usersRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
//      usersRequest.predicate = NSPredicate(format: "id != \(existingUser.id)")
//      usersRequest.fetchLimit = 1
//
//      let userRoleRequest: NSFetchRequest<NSFetchRequestResult> = Role.fetchRequest()
//      userRoleRequest.predicate = NSPredicate(format: "id != \(existingUser.roleId)")
//      userRoleRequest.fetchLimit = 1
//
//      if let image = existingUser.image {
//        let userImageRequest: NSFetchRequest<NSFetchRequestResult> = UserImage.fetchRequest()
//        userImageRequest.predicate = NSPredicate(format: "id != \(image.id)")
//
//        fetchRequests.append(userImageRequest)
//      }
//
//      fetchRequests.append(cityRequest)
//      fetchRequests.append(usersRequest)
//      fetchRequests.append(userRoleRequest)
//    }
//
//    for deleteRequest in fetchRequests {
//      let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteRequest)
//
//      do {
//        try workingContext.execute(deleteRequest)
//        saveContext(workingContext)
//      } catch {
//        print ("Error while cleaning Core Data: \(error.localizedDescription)")
//      }
//    }
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
