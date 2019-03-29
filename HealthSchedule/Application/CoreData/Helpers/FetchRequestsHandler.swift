//
//  FetchRequestsHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/27/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import CoreData

class FetchRequestsHandler {
  private unowned var contextsProviding: ContextsProviding
  
  init(provider: ContextsProviding) {
    contextsProviding = provider
  }
  
  func getCurrentUser(context: NSManagedObjectContext? = nil) -> User? {
    let currentUserId = UserDefaults.standard.integer(forKey: UserDefaultsKeys.userUniqueId.rawValue)
    if currentUserId == 0 {
      return nil
    }
    
    let workingContext = contextsProviding.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    
    fetchRequest.predicate = NSPredicate(format: "id == \(Int16(currentUserId))")
    fetchRequest.fetchLimit = 1
    fetchRequest.relationshipKeyPathsForPrefetching = ["city"]
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      return result.first
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getUser(byId id: Int, context: NSManagedObjectContext? = nil) -> User? {
    let workingContext = contextsProviding.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    
    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
    fetchRequest.fetchLimit = 1
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      return result.first
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getCties(context: NSManagedObjectContext? = nil) -> [City] {
    let workingContext = contextsProviding.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      return result
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getCtiy(byId id: Int, context: NSManagedObjectContext? = nil) -> City? {
    let workingContext = contextsProviding.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == \(Int16(id))")
    fetchRequest.fetchLimit = 1
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      return result.first
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getServices(context: NSManagedObjectContext? = nil) -> [Service] {
    let workingContext = contextsProviding.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<Service> = Service.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      return result
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getService(by id: Int, context: NSManagedObjectContext? = nil) -> Service? {
    let workingContext = contextsProviding.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<Service> = Service.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == \(Int16(id))")
    fetchRequest.fetchLimit = 1
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      return result.first
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getProviderServices(context: NSManagedObjectContext? = nil) -> [ProviderService] {
    let workingContext = contextsProviding.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<ProviderService> = ProviderService.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      return result
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getProviderService(by id: Int, context: NSManagedObjectContext? = nil) -> ProviderService? {
    let workingContext = contextsProviding.provideWorkingContext(basedOn: context)
    
    let fetchRequest: NSFetchRequest<ProviderService> = ProviderService.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == \(Int16(id))")
    fetchRequest.fetchLimit = 1
    
    do {
      let result = try workingContext.fetch(fetchRequest)
      return result.first
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
}
