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
  
  func login(login: String, password: String, complition: @escaping (User) -> Void) {
    let postBody = ["username": login, "password": password]
    
    RequestManager.signIn(body: postBody) { [weak self] (user, info, error) in
      if let _ = info {
        return
      }
      
      self?.user = user
      
      // TODO: refactor this
      if user.role.name == "provider" {
        self?.requestProviderData()
        
        complition(user)
        return
      }
      
      complition(user)
    }
  }
  
  func register(userType: UserType, _ postData: Parser.BodyDictionary, complition: @escaping (User?) -> Void) {
    RequestManager.signUp(authType: userType, body: postData) { [weak self] (user, info, error) in
      if let _ = info {
        return
      }
      
      self?.user = user
      
      complition(user)
    }
  }
  
  // MARK: - Provider requests
  
  func getProfessions(complition: @escaping ([ProviderProfession]) -> Void) {
    RequestManager.getListAsyncFor(type: ProviderProfession.self, from: .providerProfessions, RequestManager.sessionToken?.asParams()) { [weak self] list in
      self?.user?.providerData?.professions = list
      
      complition(list)
    }
  }
  
  private func requestProviderData() {
    getProfessions() { list in print("Professions obtrained!")}
    // TODO: Load rest data here
  }
}
