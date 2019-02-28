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
  case allCities = "/api/cities"
  case allProfessions = "/api/category/doctors/professions"
  
  // POST
  case signUpAsUser = "/api/register/user"
  case signUpAsProvider = "/api/register/provider"
  
  case signIn = "/api/login"
  
  // PUT
  case providerAddress = "/api/provider/address"
  
  // GET / POST / DELETE ( /{id} )
  case providerProfessions = "/api/provider/professions"
  
  // GET / PUT
}

enum RequestType: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}
