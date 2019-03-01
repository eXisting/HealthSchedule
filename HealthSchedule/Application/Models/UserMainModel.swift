//
//  UsersManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol AuthenticationingModel {
  func login(login: String, password: String, completion: @escaping (String?) -> Void)
  func register(userType: UserType, _ postData: [String: Any], completion: @escaping (String?) -> Void)
  func validateSignUpData(_ data: [String: Any]) -> Bool
}

protocol ProviderHandlingModel {
  func getProfessions(completion: @escaping (String?) -> Void)
  func saveAddress(_ address: String, completion: @escaping (String?) -> Void)
  func removeProfession(with id: Int, completion: @escaping (String?) -> Void)
}

class UserMainModel {
  
  private(set) var user: User?
  
  private func requestProviderData() {
    getProfessions() { list in print("Professions obtained!") }
    // TODO: Load rest data here
  }
}

extension UserMainModel: AuthenticationingModel {
  func login(login: String, password: String, completion: @escaping (String?) -> Void) {
    let postBody = ["username": login, "password": password]
    guard let data = Serializer.getDataFrom(json: postBody) else {
      completion(ResponseStatus.invalidData.rawValue)
      return
    }
    
    RequestManager.signIn(userData: data) {
      [weak self] (user, response) in
      if response.error != nil {
        completion(response.error)
        return
      }
      
      self?.user = user
      
      // TODO: refactor this
      if user!.role.name == "provider" {
        self?.requestProviderData()
      }
      
      completion(nil)
    }
  }
  
  func register(userType: UserType, _ postData: [String: Any], completion: @escaping (String?) -> Void) {
    guard let data = Serializer.getDataFrom(json: postData) else {
      completion(ResponseStatus.invalidData.rawValue)
      return
    }
    
    RequestManager.signUp(authType: userType, userData: data) {
      [weak self] (user, response) in
      if response.error != nil {
        completion(response.error)
        return
      }
      
      self?.user = user
      
      if userType == .provider {
        self?.requestProviderData()
      }
      
      completion(nil)
    }
  }
  
  func validateSignUpData(_ data: [String: Any]) -> Bool {
    let isValid = ValidationController.shared.validate(data[UserJsonFields.firstName.rawValue]! as! String, ofType: .name) &&
      ValidationController.shared.validate(data[UserJsonFields.lastName.rawValue]! as! String, ofType: .name) &&
      ValidationController.shared.validate(data[UserJsonFields.email.rawValue]! as! String, ofType: .email) &&
      ValidationController.shared.validate(data[UserJsonFields.password.rawValue]! as! String, ofType: .password)
    
    guard let phone = data[UserJsonFields.phone.rawValue] else {
      return isValid
    }
    
    if (phone as! String).isEmpty {
      return isValid
    }
    
    return isValid && ValidationController.shared.validate(phone as! String, ofType: .phone)
  }
}

extension UserMainModel: ProviderHandlingModel {
  func getProfessions(completion: @escaping (String?) -> Void) {
    RequestManager.getListAsync(for: ProviderProfession.self, from: .providerProfessions, RequestManager.sessionToken?.asParams()) {
      [weak self] (list, response) in
      if response.error != nil {
        completion(response.error)
        return
      }
      
      self?.user?.providerData?.professions = list
      
      completion(nil)
    }
  }
  
  func saveAddress(_ address: String, completion: @escaping (String?) -> Void) {
    guard let data = Serializer.encodeDataFrom(object: ["address": address]) else {
      completion(ResponseStatus.invalidData.rawValue)
      return
    }
    
    RequestManager.postAsync(to: Endpoints.providerAddress.rawValue, as: .put, data, RequestManager.sessionToken?.asParams()) {
      (address, response) in
      if response.error != nil {
        completion(response.error)
        return
      }
      
      completion(nil)
    }
  }
  
  func removeProfession(with id: Int, completion: @escaping (String?) -> Void) {
    let url = Endpoints.providerProfessions.rawValue + "/\(id)"
    
    RequestManager.postAsync(to: url, as: .delete, nil, RequestManager.sessionToken?.asParams()) {
      (serverMessage, response) in
      if response.error != nil {
        completion(response.error)
        return
      }
      
      completion(nil)
    }
  }
}
