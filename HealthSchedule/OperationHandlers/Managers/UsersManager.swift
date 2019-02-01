//
//  UsersManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class UsersManager {
  static let shared = UsersManager()
  
  private(set) var user: User?
  private(set) var providerData: ProviderData?
  
  private init() {}
  
  // MARK: - Authentication
  
  func login(login: String, password: String, complition: @escaping (User) -> Void) {
    let postBody = ["username": login, "password": password]
    
    RequestManager.signIn(body: postBody) { (user, info, error) in
      if let _ = info {
        return
      }
      
      complition(user)
    }
  }
  
  func register(userType: UserType, _ postData: Parser.BodyDictionary, complition: @escaping (User?) -> Void) {
    RequestManager.signUp(authType: userType, body: postData) { (user, info, error) in
      if let _ = info {
        return
      }
      
      complition(user)
    }
  }
  
  // MARK: - Provider requests
  
  func professions(complition: @escaping ([ProviderProfession]) -> Void) {
    RequestManager.getListAsyncFor(type: ProviderProfession.self, from: .providerProfessions, RequestManager.sessionToken?.asParams()) { list in
      complition(list)
    }
  }
}
