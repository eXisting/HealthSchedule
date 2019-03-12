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
  
  let modelName = "MainCoreDataContainer"
  
  let userEntity = "User"
  let userImageEntity = "UserImage"
  let cityEntity = "City"

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
  
  // MARK: - Core Data Saving support
  
  func saveData() {
    saveContext(persistentContainer.viewContext)
    
    // TODO: -Remove all except cached 10-20 records for next launch fetch
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
  
  lazy var resultController: NSFetchedResultsController<User> = {
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
  
  // MARK: Fetch requests
  
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
  
  // MARK: Actions
  
  func insertUsers(from remoteUsers: [RemoteUser]) {
    let backgroundContext = persistentContainer.newBackgroundContext()
    
    let userEntityObject = NSEntityDescription.entity(forEntityName: userEntity, in: backgroundContext)
    
    for remoteUser in remoteUsers {
      let user = NSManagedObject(entity: userEntityObject!, insertInto: backgroundContext) as! User
      
      buildBasicUserFields(for: user, remoteUser)
      
      if let remoteImage = remoteUser.photo {
        let photoEntity = NSEntityDescription.entity(forEntityName: userImageEntity, in: backgroundContext)
        let userImage = NSManagedObject(entity: photoEntity!, insertInto: backgroundContext) as! UserImage
        
        buildBasicFields(for: userImage, with: user.id, remoteImage)
        
        user.image = userImage
        userImage.user = user
      }
      
      if let remoteCity = remoteUser.city {
        let userCityEntity = NSEntityDescription.entity(forEntityName: cityEntity, in: backgroundContext)
        let userCity = NSManagedObject(entity: userCityEntity!, insertInto: backgroundContext) as! City
        
        build(city: userCity, with: user, remoteCity)
      }
      
      backgroundContext.insert(user)
      backgroundContext.processPendingChanges()
      
      saveContext(backgroundContext)
    }
  }
}

extension DataBaseManager {
  private func buildBasicUserFields(for user: User, _ remoteUser: RemoteUser) {
    user.name = remoteUser.firstName + remoteUser.lastName
    user.email = remoteUser.email
    user.phone = remoteUser.phone
    user.birthday = remoteUser.birthday
    
    user.id = Int32(remoteUser.id)
    user.roleId = Int16(remoteUser.role.id)
    user.cityId = Int16(remoteUser.city!.id)
  }
  
  private func buildBasicFields(for image: UserImage, with userId: Int32, _ remoteImage: ProfileImage) {
    image.id = Int32(remoteImage.id)
    image.url = remoteImage.url
    image.userId = userId
  }
  
  private func build(city: City, with user: User, _ remoteCity: RemoteCity) {
    city.id = Int16(remoteCity.id)
    city.name = remoteCity.name
    
    city.addToUser(user)
    user.city = city
  }
}
