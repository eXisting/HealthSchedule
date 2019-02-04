//
//  UsersManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class UserManager {
  static let shared = UserManager()
  
  private(set) var user: User?
  
  private init() {}
  
  // MARK: - Authentication
  
  func login(login: String, password: String, completion: @escaping (User) -> Void) {
    let postBody = ["username": login, "password": password]
    guard let data = Serializer.getDataFrom(json: postBody) else {
      return
    }
    
    RequestManager.signIn(userData: data) { [weak self] (user, info, error) in
      if let _ = info {
        return
      }
      
      self?.user = user
      
      // TODO: refactor this
      if user.role.name == "provider" {
        self?.requestProviderData()
        
        completion(user)
        return
      }
      
      completion(user)
    }
  }
  
  func register(userType: UserType, _ postData: [String: Any], completion: @escaping (User?) -> Void) {
    guard let data = Serializer.getDataFrom(json: postData) else {
      return
    }
    
    RequestManager.signUp(authType: userType, userData: data) { [weak self] (user, info, error) in
      if let _ = info {
        return
      }
      
      self?.user = user
      
      completion(user)
    }
  }
  
  // MARK: - Provider requests
  
  func getProfessions(completion: @escaping ([ProviderProfession]) -> Void) {
    RequestManager.getListAsyncFor(type: ProviderProfession.self, from: .providerProfessions, RequestManager.sessionToken?.asParams()) { [weak self] list in
      self?.user?.providerData?.professions = list
      
      completion(list)
    }
  }
  
  func saveAddress(address: String, completion: @escaping (String) -> Void) {
    guard let data = Serializer.encodeDataFrom(object: ["address": address]) else {
      completion("Cannot encode in save professions")
      return
    }
    
    RequestManager.postAsync(to: .providerAddress, as: .put, data, RequestManager.sessionToken?.asParams()) { status in
      if status == .ok {
        completion("New address saved successfuly!")
      } else {
        completion("Server error!")
      }
    }
  }
    
  private func requestProviderData() {
    getProfessions() { list in print("Professions obtained!")}
    // TODO: Load rest data here
  }
}
