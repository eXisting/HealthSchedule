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
  case requests = "/api/user/requests"

  // GET COMMON
  case allCities = "/api/cities"
  case allProfessions = "/api/category/doctors/professions"
  case allServices = "/api/services/all"
  case allServicesForCity = "/api/services"

  // POST
  case signUpAsUser = "/api/register/user"
  case signUpAsProvider = "/api/register/provider"
  
  case signIn = "/api/login"
  
  // PUT
  case providerAddress = "/api/provider/address"
  case updateUserInfo = "/api/user/info"
  
  // GET / POST / DELETE ( /{id} )
  case providerProfessions = "/api/provider/professions"
  case providerServices = "/api/provider/services"

  // GET / PUT
  case scheduleTemplate = "/api/provider/schedules"
  case password = "/api/user/password"
}

enum RequestType: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}
