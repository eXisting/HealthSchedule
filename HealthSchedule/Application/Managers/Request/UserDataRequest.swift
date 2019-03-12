//
//  UsersManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol AuthenticationProviding {
  func refreshToken(completion: @escaping () -> Void)
  func login(login: String, password: String, completion: @escaping (String?) -> Void)
  func register(userType: UserType, _ postData: [String: Any], completion: @escaping (String?) -> Void)
}

protocol ProviderInfoRequesting {
  func getProfessions(completion: @escaping (String?) -> Void)
  func saveAddress(_ address: String, completion: @escaping (String?) -> Void)
  func removeProfession(with id: Int, completion: @escaping (String?) -> Void)
}

protocol CommonDataRequesting {
  func getRequests(completion: @escaping () -> Void)
  func getImage(from url: String, completion: @escaping (Data) -> Void)
  func getRecomendations()
}

class UserDataRequest {
  
  private static var user: RemoteUser?
  
  private let requestsManager = RequestManager()
  private let databaseManager = DataBaseManager.shared
    
  private func requestProviderData() {
    getProfessions() { list in print("Professions obtained!") }
    // TODO: Load rest data here
  }
}

extension UserDataRequest: CommonDataRequesting {
  func getImage(from url: String, completion: @escaping (Data) -> Void) {
    requestsManager.getDataAsync(from: url) { (data) in
      guard let imageData = data else {
        return
      }
      
      completion(imageData)
    }
  }
  
  func getRequests(completion: @escaping () -> Void) {
    requestsManager.getListAsync(for: RemoteRequest.self, from: .requests, RequestManager.sessionToken.asParams()) {
      (list, response) in
      print(list)
    }
  }
  
  func getCities(completion: @escaping () -> Void) {
    
  }
  
  func getRecomendations() {
    
  }
}

extension UserDataRequest: AuthenticationProviding {
  func refreshToken(completion: @escaping () -> Void) {    
  }
  
  func login(login: String, password: String, completion: @escaping (String?) -> Void) {
    let postBody = ["username": login, "password": password]
    guard let data = Serializer.getDataFrom(json: postBody) else {
      completion(ResponseStatus.invalidData.rawValue)
      return
    }
    
    requestsManager.signIn(userData: data) {
      [weak self] (user, response) in
      guard let remoteUser = user else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if response.error != nil {
        completion(response.error)
        return
      }
      
      if self?.databaseManager.getCurrentUser() == nil {
        self?.databaseManager.insertUsers(from: [remoteUser])
      }
      
      // TODO: refactor this
      if remoteUser.role.name == "provider" {
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
    
    requestsManager.signUp(authType: userType, userData: data) {
      [weak self] (user, response) in
      guard let remoteUser = user else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if response.error != nil {
        completion(response.error)
        return
      }
      
      UserDataRequest.user = remoteUser
      
      if userType == .provider {
        self?.requestProviderData()
      }
      
      completion(nil)
    }
  }
}

extension UserDataRequest: ProviderInfoRequesting {
  func getProfessions(completion: @escaping (String?) -> Void) {
    requestsManager.getListAsync(for: RemoteProviderProfession.self, from: .providerProfessions, RequestManager.sessionToken.asParams()) {
      (list, response) in
      if response.error != nil {
        completion(response.error)
        return
      }
      
      UserDataRequest.user?.providerData?.professions = list
      
      completion(nil)
    }
  }
  
  func saveAddress(_ address: String, completion: @escaping (String?) -> Void) {
    guard let data = Serializer.encodeDataFrom(object: ["address": address]) else {
      completion(ResponseStatus.invalidData.rawValue)
      return
    }
    
    requestsManager.postAsync(to: Endpoints.providerAddress.rawValue, as: .put, data, RequestManager.sessionToken.asParams()) {
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
    
    requestsManager.postAsync(to: url, as: .delete, nil, RequestManager.sessionToken.asParams()) {
      (serverMessage, response) in
      if response.error != nil {
        completion(response.error)
        return
      }
      
      completion(nil)
    }
  }
}