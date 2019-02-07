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
  
  func login(login: String, password: String, completion: @escaping (ResponseStatus) -> Void) {
    let postBody = ["username": login, "password": password]
    guard let data = Serializer.getDataFrom(json: postBody) else {
      return
    }
    
    RequestManager.signIn(userData: data) { [weak self] (user, status) in
      self?.user = user
      
      // TODO: refactor this
      if user!.role.name == "provider" {
        self?.requestProviderData()
      }
      
      completion(status)
    }
  }
  
  func register(userType: UserType, _ postData: [String: Any], completion: @escaping (ResponseStatus) -> Void) {
    guard let data = Serializer.getDataFrom(json: postData) else {
      completion(.invalidData(message: "Data is invalid!"))
      return
    }
    
    RequestManager.signUp(authType: userType, userData: data) { [weak self] (user, status) in
      self?.user = user
      
      completion(status)
    }
  }
  
  // MARK: - Provider requests
  
  func getProfessions(completion: @escaping (ResponseStatus) -> Void) {
    RequestManager.getListAsync(for: ProviderProfession.self, from: .providerProfessions, RequestManager.sessionToken?.asParams()) { [weak self] (list, status) in
      self?.user?.providerData?.professions = list
      
      completion(status)
    }
  }
  
  func saveAddress(_ address: String, completion: @escaping (ResponseStatus) -> Void) {
    guard let data = Serializer.encodeDataFrom(object: ["address": address]) else {
      completion(.invalidData(message: "Data is invalid!"))
      return
    }
    
    RequestManager.postAsync(to: Endpoints.providerAddress.rawValue, as: .put, data, RequestManager.sessionToken?.asParams()) { (address, status) in
      completion(status)
    }
  }
  
  func removeProfessionWith(id: Int, completion: @escaping (ResponseStatus) -> Void) {
    let url = Endpoints.providerProfessions.rawValue + "/\(id)"
    
    RequestManager.postAsync(to: url, as: .delete, nil, RequestManager.sessionToken?.asParams()) { (response, status) in
      completion(status)
    }
  }
  
  private func requestProviderData() {
    getProfessions() { list in print("Professions obtained!") }
    // TODO: Load rest data here
  }
}
