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
  func login(login: String, password: String, completion: @escaping (String) -> Void)
  func register(userType: UserType, _ postData: Parser.JsonDictionary, completion: @escaping (String) -> Void)
}

protocol ProviderInfoRequesting {
  /// Returns curent provider professions for nil providerId
  func getProviderProfessions(with providerId: Int?, completion: @escaping (String) -> Void)
  func createUpdateProviderProfession(with data: Parser.JsonDictionary, isCreate: Bool, completion: @escaping (String) -> Void)
  func removeProfession(with id: Int, completion: @escaping (String) -> Void)

  func saveAddress(_ address: String, completion: @escaping (String) -> Void)
  
  func getScheduleTemplate(completion: @escaping (String) -> Void)
  func saveScheduleTemplates(_ data: [String: [Dictionary<String, Any>]], completion: @escaping (String) -> Void)

  func getProviderServices(completion: @escaping (String) -> Void)
  func createUpdateProviderService(with data: Parser.JsonDictionary, isCreate: Bool, completion: @escaping (String) -> Void)
  func removeProviderService(with id: Int, completion: @escaping (String) -> Void)
}

protocol CommonDataRequesting {
  func getRequests(completion: @escaping (String) -> Void)
  func getUser(_ completion: @escaping (String) -> Void)
  
  func getUser(by id: Int, _ completion: @escaping (String) -> Void)
}

protocol UserDataUpdating {
  func updateInfo(with data: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
  func changePassword(with data: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
  func updatePhoto(with photoData: Data, infoDict: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
  
  func deleteRequest(id: Int, _ completion: @escaping (String) -> Void)
  func updateRequest(id: Int, with collectedData: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
  func makeRequests(toProviderWith collectedData: Parser.JsonDictionary, _ completion: @escaping (String) -> Void)
}

class UserDataRequest {
  private let requestsManager = RequestManager()
  
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
  
  func updatePhoto(with photoData: Data, infoDict: Parser.JsonDictionary, _ completion: @escaping (String) -> Void) {
    requestsManager.uploadImage(photoData, infoDict) {
      [weak self] data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.getUser(completion)
    }
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
    let endpoint = "\(Endpoints.providerRequests.rawValue)/\(id)"
    
    requestsManager.postAsync(to: endpoint, as: .put, collectedData, RequestManager.sessionToken.asParams()) {
      [weak self] serverData, response in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.getRequest(id) { innerResponse in
        completion(innerResponse)
      }
    }
  }
  
  func makeRequests(toProviderWith collectedData: Parser.JsonDictionary, _ completion: @escaping (String) -> Void) {
    requestsManager.postAsync(to: Endpoints.userRequests.rawValue, as: .post, collectedData, RequestManager.sessionToken.asParams()) {
      [weak self] data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.getRequests(completion: completion)
    }
  }
  
  func deleteRequest(id: Int, _ completion: @escaping (String) -> Void) {
    let endpoint = "\(Endpoints.providerRequests.rawValue)/\(id)"
    
    requestsManager.postAsync(to: endpoint, as: .delete, nil, RequestManager.sessionToken.asParams()) {
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
      provider, response in
      
      guard let remoteUser = provider else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if let error = response.error {
        completion(error)
        return
      }
      
      DataBaseManager.shared.insertUpdateUsers(from: [remoteUser])
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func getUser(_ completion: @escaping (String) -> Void) {
    requestsManager.getAsync(for: RemoteUser.self, from: .user, RequestManager.sessionToken.asParams()) {
      user, response in
      
      guard let remoteUser = user else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if let error = response.error {
        completion(error)
        return
      }
      
      DataBaseManager.shared.insertUpdateUsers(from: [remoteUser])
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func getRequests(completion: @escaping (String) -> Void) {
    guard let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      fatalError()
    }
    
    let endpoint = Int(user.roleId) == UserType.client.rawValue ? Endpoints.userRequests : Endpoints.providerRequests
    
    requestsManager.getListAsync(for: RemoteRequest.self, from: endpoint, RequestManager.sessionToken.asParams()) {
      list, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      DataBaseManager.shared.insertUpdateRequests(from: list)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  private func getRequest(_ id: Int, _ completion: @escaping (String) -> Void) {
    guard let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      fatalError()
    }
    
    let endpoint = Int(user.roleId) == UserType.client.rawValue ? Endpoints.userRequests : Endpoints.providerRequests
    let route = "\(endpoint.rawValue)/\(id)"
    
    requestsManager.getAsync(for: RemoteRequest.self, from: route, RequestManager.sessionToken.asParams()) {
      element, response in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      guard let remoteRequest = element else { completion(ResponseStatus.serverError.rawValue); return }
      
      DataBaseManager.shared.insertUpdateRequests(from: [remoteRequest])
      
      completion(ResponseStatus.success.rawValue)
    }
  }
}

extension UserDataRequest: AuthenticationProviding {
  func refreshToken(completion: @escaping () -> Void) {
    // TODO
  }
  
  func login(login: String, password: String, completion: @escaping (String) -> Void) {
    let postBody = ["username": "provider@example.org", "password": password]
//    let postBody = ["username": login, "password": password]
    requestsManager.signIn(userData: postBody) { user, response in
      guard let remoteUser = user else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if let error = response.error {
        completion(error)
        return
      }
      
      DataBaseManager.shared.insertUpdateUsers(from: [remoteUser], context: DataBaseManager.shared.mainContext)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func register(userType: UserType, _ postData: Parser.JsonDictionary, completion: @escaping (String) -> Void) {
    requestsManager.signUp(authType: userType, userData: postData) { user, response in
      guard let remoteUser = user else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      if let error = response.error {
        completion(error)
        return
      }
      
      DataBaseManager.shared.insertUpdateUsers(from: [remoteUser], context: DataBaseManager.shared.mainContext)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
}

extension UserDataRequest: ProviderInfoRequesting {
  func getProviderProfessions(with providerId: Int?, completion: @escaping (String) -> Void) {
    var params = RequestManager.sessionToken.asParams()
    if let id = providerId {
      params[ProfessionJsonFields.providerId.rawValue] = String(id)      
    }
    
    requestsManager.getListAsync(for: RemoteProviderProfession.self, from: .providerProfessions, params) {
      list, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      DataBaseManager.shared.insertUpdateProviderProfessions(from: list)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func removeProfession(with id: Int, completion: @escaping (String) -> Void) {
    let url = "\(Endpoints.providerProfessions.rawValue)/\(id)"
    
    requestsManager.postAsync(to: url, as: .delete, nil, RequestManager.sessionToken.asParams()) {
      data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func removeProviderService(with id: Int, completion: @escaping (String) -> Void) {
    let url = "\(Endpoints.providerServices.rawValue)/\(id)"
    
    requestsManager.postAsync(to: url, as: .delete, nil, RequestManager.sessionToken.asParams()) {
      [weak self] data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func saveAddress(_ address: String, completion: @escaping (String) -> Void) {
    let data = [ProviderDataJsonFields.address.rawValue: address]
    requestsManager.postAsync(to: Endpoints.address.rawValue, as: .put, data, RequestManager.sessionToken.asParams()) {
      [weak self] data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      guard let address = data as? [String: Any],
        let addressId = address[ProviderDataJsonFields.addressId.rawValue] as? Int else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      self?.getUserAddress(by: addressId, completion)
    }
  }
  
  func getProviderServices(completion: @escaping (String) -> Void) {
    requestsManager.getListAsync(for: RemoteProviderService.self, from: .providerServices, RequestManager.sessionToken.asParams()) {
      list, response in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      DataBaseManager.shared.insertUpdateProviderServices(from: list)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func createUpdateProviderProfession(with data: Parser.JsonDictionary, isCreate: Bool, completion: @escaping (String) -> Void) {
    var endpoint = Endpoints.providerProfessions.rawValue
    var requestType: RequestMethodType = .post
    
    if !isCreate {
      endpoint.append("/")
      endpoint.append(data[ProfessionJsonFields.id.rawValue]!)
      
      requestType = .put
    }
    
    requestsManager.postAsync(to: endpoint, as: requestType, data, RequestManager.sessionToken.asParams()) {
      [weak self] serverMessage, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      if requestType == .put {
        guard let professionId = Int(data[ProfessionJsonFields.id.rawValue]!) else {
          completion(ResponseStatus.applicationError.rawValue)
          return
        }
        
        self?.getProviderProfession(by: professionId, completion: completion)
      } else {
        self?.getProviderProfessions(with: nil, completion: completion)
      }
    }
  }
  
  func createUpdateProviderService(with data: Parser.JsonDictionary, isCreate: Bool, completion: @escaping (String) -> Void) {
    var endpoint = Endpoints.providerServices.rawValue
    var requestType: RequestMethodType = .post
    
    if !isCreate {
      endpoint.append("/")
      endpoint.append(data[ProviderServiceJsonFields.id.rawValue]!)
      
      requestType = .put
    }
    
    requestsManager.postAsync(to: endpoint, as: requestType, data, RequestManager.sessionToken.asParams()) {
      [weak self] serverMessage, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      if requestType == .put {
        guard let id = Int(data[ProviderServiceJsonFields.id.rawValue]!) else {
          completion(ResponseStatus.applicationError.rawValue)
          return
        }
        
        self?.getProviderService(by: id, completion: completion)
      } else {
        self?.getProviderServices(completion: completion)
      }
    }
  }
  
  func getScheduleTemplate(completion: @escaping (String) -> Void) {
    requestsManager.getListAsync(for: RemoteScheduleTemplateDay.self, from: Endpoints.scheduleTemplate, RequestManager.sessionToken.asParams()) {
      list, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      DataBaseManager.shared.insertUpdateScheduleDayTemplate(from: list)
      
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
  
  private func getProviderProfession(by id: Int, completion: @escaping (String) -> Void) {
    let endpoint = "\(Endpoints.providerProfessions.rawValue)/\(id)"
    
    requestsManager.getAsync(for: RemoteProviderProfession.self, from: endpoint, RequestManager.sessionToken.asParams()) {
      data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      guard let providerProfession = data else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      DataBaseManager.shared.insertUpdateProviderProfessions(from: [providerProfession])
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  private func getProviderService(by id: Int, completion: @escaping (String) -> Void) {
    let endpoint = "\(Endpoints.providerServices.rawValue)/\(id)"
    
    requestsManager.getAsync(for: RemoteProviderService.self, from: endpoint, RequestManager.sessionToken.asParams()) {
      data, response in
      if let error = response.error {
        completion(error)
        return
      }
      
      guard let providerSerivce = data else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      DataBaseManager.shared.insertUpdateProviderServices(from: [providerSerivce])
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  private func getUserAddress(by id: Int, _ completion: @escaping (String) -> Void) {
    var params = RequestManager.sessionToken.asParams()
    params[ProviderDataJsonFields.addressId.rawValue] = String(id)
    
    requestsManager.getAsync(for: RemoteAddress.self, from: Endpoints.address.rawValue, params) {
      data, response in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      guard let address = data,
        let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
          completion(ResponseStatus.applicationError.rawValue)
          return
      }
      
      DataBaseManager.shared.insertUpdateUserAddress(from: address, for: Int(user.id))
      
      completion(ResponseStatus.success.rawValue)
    }
  }
}
