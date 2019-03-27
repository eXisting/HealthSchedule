//
//  FetchRequestsHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/27/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import CoreData

class FetchRequestsHandler {
  unowned var persistentContainer: NSPersistentContainer
  
  init(container: NSPersistentContainer) {
    persistentContainer = container
  }
  
  func getCurrentUser() -> User? {
    let currentUserId = UserDefaults.standard.integer(forKey: UserDefaultsKeys.userUniqueId.rawValue)
    if currentUserId == 0 {
      return nil
    }
    
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    
    fetchRequest.predicate = NSPredicate(format: "id == \(Int16(currentUserId))")
    
    do {
      let result = try persistentContainer.viewContext.fetch(fetchRequest)
      return result.first
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getCties() -> [City] {
    guard let currentUser = getCurrentUser() else {
      return []
    }
    
    let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    fetchRequest.predicate = NSPredicate(format: "id != \(Int16(currentUser.id))")
    
    do {
      let result = try persistentContainer.viewContext.fetch(fetchRequest)
      return result
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getServices() -> [Service] {
    let fetchRequest: NSFetchRequest<Service> = Service.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    do {
      let result = try persistentContainer.viewContext.fetch(fetchRequest)
      return result
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getService(by id: Int, context: NSManagedObjectContext) -> Service? {
    let fetchRequest: NSFetchRequest<Service> = Service.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id != \(Int16(id))")
    
    do {
      let result = try context.fetch(fetchRequest)
      return result.first
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getProviderServices() -> [ProviderService] {
    let fetchRequest: NSFetchRequest<ProviderService> = ProviderService.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
    
    do {
      let result = try persistentContainer.viewContext.fetch(fetchRequest)
      return result
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
  
  func getProviderService(by id: Int, context: NSManagedObjectContext) -> ProviderService? {
    let fetchRequest: NSFetchRequest<ProviderService> = ProviderService.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id != \(Int16(id))")
    
    do {
      let result = try context.fetch(fetchRequest)
      return result.first
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
  }
}
