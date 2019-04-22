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
  
  func getScheduleTemplate(completion: @escaping (String) -> Void)
  func saveScheduleTemplates(_ data: [String: [Dictionary<String, Any>]], completion: @escaping (String) -> Void)

  func getProviderServices(completion: @escaping (String) -> Void)
  func createUpdateProviderService(with data: Parser.JsonDictionary, isCreate: Bool, completion: @escaping (String) -> Void)
}

protocol CommonDataRequesting {
  func getRequests(completion: @escaping (String) -> Void)
  func getUser(_ completion: @escaping (String) -> Void)
  
  func getUser(by id: Int, _ completion: @escaping (String) -> Void)
}

protocol UserDataUpdating {
  func updateInfo(with data: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
  func changePassword(with data: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
  func updatePhoto(with photoData: Data, _ completion: @escaping (String) -> Void)
  
  func updateRequest(id: Int, with collectedData: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
  func makeRequests(toProviderWith collectedData: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
}

class UserDataRequest {
  private let requestsManager = RequestManager()
  private let databaseManager = DataBaseManager.shared
  
  typealias FreshScheduleDayData = (dayIndex: Int16, start: Date, end: Date, working: Bool)
}

extension UserDataRequest: UserDataUpdating {
  func updateInfo(with collectedData: Parser.JsonDictionary, _ completion: @escaping (String) -> Void) {
    let data = Parser.processGeneralUserData(collectedData)
    
    requestsManager.postAsync(to: Endpoints.updateUserInfo.rawValue, as: .put, data, RequestManager.sessionToken.asParams()) {
        [weak self] serverData, response in
        if let error = response.error {
          completion(error)
          return
        }
        
        self?.getUser(completion)
      }
  }
  
  func updatePhoto(with photoData: Data, _ completion: @escaping (String) -> Void) {
    // TODO
  }
  
  func changePassword(with data: Parser.JsonDictionary, _ completion: @escaping (String) -> Void) {
    requestsManager.postAsync(to: Endpoints.password.rawValue, as: .put, data, RequestManager.sessionToken.asParams()) {
      data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func updateRequest(id: Int, with collectedData: Parser.JsonDictionary, _ completion: @escaping (String) -> Void) {
    guard let user = databaseManager.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      fatalError()
    }
    
    let endpoint = Int(user.roleId) == UserType.client.rawValue ? Endpoints.userRequests : Endpoints.providerRequests
    let route = "\(endpoint)/\(id)"
    
    requestsManager.postAsync(to: route, as: .put, collectedData, RequestManager.sessionToken.asParams()) {
      [weak self] serverData, response in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.getRequest(id) { innerResponse in completion(innerResponse) }
    }
  }
  
  func makeRequests(toProviderWith collectedData: Parser.JsonDictionary, _ completion: @escaping (String) -> Void) {
    requestsManager.postAsync(to: Endpoints.userRequests.rawValue, as: .post, collectedData, RequestManager.sessionToken.asParams()) {
      data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      completion(ResponseStatus.success.rawValue)
    }
  }
}

extension UserDataRequest: CommonDataRequesting {
  func getUser(by id: Int, _ completion: @escaping (String) -> Void) {
    let endpoint = "\(Endpoints.providerById.rawValue)/\(id)"
    
    requestsManager.getAsync(for: RemoteUser.self, from: endpoint, RequestManager.sessionToken.asParams()) {
      [weak self] provider, response in
      
      guard let remoteUser = provider else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.databaseManager.insertUpdateUsers(from: [remoteUser])
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func getUser(_ completion: @escaping (String) -> Void) {
    requestsManager.getAsync(for: RemoteUser.self, from: .user, RequestManager.sessionToken.asParams()) {
      [weak self] (user, response) in
      
      guard let remoteUser = user else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.databaseManager.insertUpdateUsers(from: [remoteUser], context: DataBaseManager.shared.mainContext)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func getRequests(completion: @escaping (String) -> Void) {
    guard let user = databaseManager.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      fatalError()
    }
    
    let endpoint = Int(user.roleId) == UserType.client.rawValue ? Endpoints.userRequests : Endpoints.providerRequests
    
    requestsManager.getListAsync(for: RemoteRequest.self, from: endpoint, RequestManager.sessionToken.asParams()) {
      [weak self] (list, response) in
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.databaseManager.insertUpdateRequests(from: list)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  private func getRequest(_ id: Int, _ completion: @escaping (String) -> Void) {
    guard let user = databaseManager.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      fatalError()
    }
    
    let endpoint = Int(user.roleId) == UserType.client.rawValue ? Endpoints.userRequests : Endpoints.providerRequests
    let route = "\(endpoint)/\(id)"
    
    requestsManager.getAsync(for: RemoteRequest.self, from: route, RequestManager.sessionToken.asParams()) {
      [weak self] element, response in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      guard let remoteRequest = element else { completion(ResponseStatus.serverError.rawValue); return }
      
      self?.databaseManager.insertUpdateRequests(from: [remoteRequest])
      
      completion(ResponseStatus.success.rawValue)
    }
  }
}

extension UserDataRequest: AuthenticationProviding {
  func refreshToken(completion: @escaping () -> Void) {
    // TODO
  }
  
  func login(login: String, password: String, completion: @escaping (String?) -> Void) {
    let postBody = ["username": "provider@example.org", "password": password]
//    let postBody = ["username": login, "password": password]
    requestsManager.signIn(userData: postBody) {
      [weak self] (user, response) in
      guard let remoteUser = user else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if response.error != nil {
        completion(response.error)
        return
      }
      
      self?.databaseManager.insertUpdateUsers(from: [remoteUser], context: DataBaseManager.shared.mainContext)
      
      completion(nil)
    }
  }
  
  func register(userType: UserType, _ postData: [String: Any], completion: @escaping (String?) -> Void) {
    guard let data = postData as? Parser.JsonDictionary else {
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
      
      self?.databaseManager.insertUpdateUsers(from: [remoteUser], context: DataBaseManager.shared.mainContext)
      
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
      
      // TODO: Insert into core data
      
      completion(nil)
    }
  }
  
  func saveAddress(_ address: String, completion: @escaping (String?) -> Void) {
    let data = ["address": address]
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
  
  func getProviderServices(completion: @escaping (String) -> Void) {
    requestsManager.getListAsync(for: RemoteProviderService.self, from: .providerServices, RequestManager.sessionToken.asParams()) {
      [weak self] list, response in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.databaseManager.insertUpdateProviderServices(from: list)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func createUpdateProviderService(with data: Parser.JsonDictionary, isCreate: Bool, completion: @escaping (String) -> Void) {
    var endpoint = Endpoints.providerServices.rawValue
    var requestType: RequestType = .post
    
    if !isCreate {
      endpoint.append("/")
      endpoint.append(data[ProviderServiceJsonFields.id.rawValue]!)
      
      requestType = .put
    }
    
    requestsManager.postAsync(to: endpoint, as: requestType, data, RequestManager.sessionToken.asParams()) {
      serverMessage, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func getScheduleTemplate(completion: @escaping (String) -> Void) {
    requestsManager.getListAsync(for: RemoteScheduleTemplateDay.self, from: Endpoints.scheduleTemplate, RequestManager.sessionToken.asParams()) {
      [weak self] list, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.databaseManager.insertUpdateScheduleDayTemplate(from: list)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func saveScheduleTemplates(_ data: Parser.JsonArrayDictionary, completion: @escaping (String) -> Void) {
    guard let postData = Serializer.getDataFrom(json: data) else {
      return
    }
    
    requestsManager.postAsync(to: Endpoints.scheduleTemplate.rawValue, as: .put, postData, RequestManager.sessionToken.asParams()) {
      [weak self] serverMessage, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.getScheduleTemplate(completion: completion)
    }
  }
}
