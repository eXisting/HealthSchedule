//
//  RequestEnums.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

enum Endpoints: String {
  // GET
  case user = "/api/user"
  case provider = "/api/provider"
  case userRequests = "/api/user/requests"
  
  // GET COMMON
  case allCities = "/api/cities"
  case availableProvidersByInterval = "/api/provider/available-times"
  case allServices = "/api/services/all/2" // 2 - is current category for app
  case allProfessions = "/api/category/2/professions" // 2 - is current category for app
  
  // POST
  case signUpAsUser = "/api/register/user"
  case signUpAsProvider = "/api/register/provider"
  
  case signIn = "/api/login"
  
  // PUT
  case updateUserInfo = "/api/user/info"

  // GET / PUT
  case scheduleTemplate = "/api/provider/schedules"
  case password = "/api/user/password"
  case address = "/api/provider/address"
  
  // GET / POST / DELETE ( /{id} )
  case providerRequests = "/api/provider/requests"
  case providerProfessions = "/api/provider/professions"
  case providerServices = "/api/provider/services"
  case providerById = "/api/user/providers"
  case services = "/api/services"
}

enum RequestType: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}
