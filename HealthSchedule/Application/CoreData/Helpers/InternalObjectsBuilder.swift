//
//  InternalObjectsBuilder.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/27/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import CoreData

class InternalObjectsBuilder {
  private unowned var fetchHandler: FetchRequestsHandler
  
  init(handler: FetchRequestsHandler) {
    fetchHandler = handler
  }
  
  func build(user: User, _ remoteUser: RemoteUser, context: NSManagedObjectContext) {
    user.name = "\(remoteUser.firstName) \(remoteUser.lastName)"
    user.email = remoteUser.email
    user.phone = remoteUser.phone
    user.birthday = remoteUser.birthday
    
    user.id = Int32(remoteUser.id)
    
    if let city = remoteUser.city {
      user.cityId = Int16(city.id)
      
      let city = fetchHandler.getCity(byId: Int(user.cityId), context: context)
      city?.addToUser(user)
      user.city = city
    }
    
    if let role = remoteUser.role {
      user.roleId = Int16(role.id)
    } else {
      user.roleId = Int16(4) // magic number
    }
    
    if let address = remoteUser.address {
      user.addressId = Int16(address.id)
    }
  }
  
  func build(address: Address, attachedUser: User, _ remote: RemoteAddress, context: NSManagedObjectContext) {
    address.id = Int16(remote.id)
    address.address = remote.address
        
    attachedUser.address = address
    address.user = attachedUser
  }
  
  func build(providerProfession: ProviderProfession, _ remote: RemoteProviderProfession, context: NSManagedObjectContext) {
    providerProfession.id = Int16(remote.id)
    providerProfession.cityId = Int16(remote.cityId)
    providerProfession.companyName = remote.companyName
    providerProfession.professionId = Int32(remote.professionId)
    providerProfession.start = remote.startAt
    providerProfession.end = remote.endAt
    providerProfession.providerId = Int32(remote.providerId)
    
    guard let profession = fetchHandler.getProfession(by: remote.professionId, context: context),
      let city = fetchHandler.getCity(byId: remote.cityId, context: context),
      let provider = fetchHandler.getUser(byId: remote.providerId, context: context) else {
      fatalError("You must insert cities, professions and provier before ProviderProfession!")
    }
    
    providerProfession.city = city
    city.addToProviderProfession(providerProfession)
        
    providerProfession.provider = provider
    provider.addToProviderProfession(providerProfession)
    
    providerProfession.profession = profession
    profession.addToProviderProfession(providerProfession)
  }
  
  func build(profession: Profession, _ remote: RemoteProfession, context: NSManagedObjectContext) {
    profession.id = Int32(remote.id)
    profession.categoryId = Int16(remote.categoryId)
    profession.name = remote.title
  }
  
  func build(role: Role, attachedUser: User, _ remoteRole: RemoteRole, context: NSManagedObjectContext) {
    role.id = Int16(remoteRole.id)
    role.name = remoteRole.title
    
    role.addToUser(attachedUser)

    guard let roleUsers = role.user else { return }
    
    for element in roleUsers {
      guard let user = (element as? User) else { continue }
      
      user.role = role
      user.roleId = role.id
      role.addToUser(user)
    }
  }
  
  func build(day: ScheduleDayTemplate, _ index: Int, attachedUser: User, _ remote: RemoteScheduleTemplateDay, context: NSManagedObjectContext) {
    day.id = Int16(remote.id)
    day.working = remote.working
    day.providerId = attachedUser.id
    day.weekDayIndex = Int16(index)
    
    let datePart = DateManager.shared.getDateAccordingToThisWeek(weekDayIndex: index)

    day.start = DateManager.shared.combineDateWithTime(date: datePart, time: remote.startTime)
    day.end = DateManager.shared.combineDateWithTime(date: datePart, time: remote.endTime)
    
    day.provider = attachedUser
    attachedUser.addToScheduleDayTemplate(day)
  }
  
  func build(image: UserImage, with userId: Int, _ remoteImage: ProfileImage, context: NSManagedObjectContext) {
    image.id = Int32(remoteImage.id)
    image.url = remoteImage.url
    image.userId = Int32(userId)
    
    let user = fetchHandler.getUser(byId: userId, context: context)
    user?.image = image
    image.user = user
  }
  
  func build(city: City, _ remoteCity: RemoteCity) {
    city.id = Int16(remoteCity.id)
    city.name = remoteCity.title
  }
  
  func build(service: Service, _ remoteService: RemoteService, context: NSManagedObjectContext) {
    service.id = Int16(remoteService.id)
    service.name = remoteService.title
    service.professionId = Int16(remoteService.professionId)
    
    guard let profession = fetchHandler.getProfession(by: remoteService.professionId, context: context) else {
      fatalError("You must insert professions before services!")
    }
    
    profession.addToService(service)
    service.profession = profession
  }
  
  func build(request: Request, _ remote: RemoteRequest, context: NSManagedObjectContext) {
    request.id = Int16(remote.id)
    request.requestDescription = remote.description
    request.requestedAt = remote.requestAt
    request.status = Int16(remote.status.value)
    request.customerId = Int16(remote.customerId)
    request.serviceId = Int16(remote.providerService.service.id)
    request.isUserSide = remote.isUserSide
    
    if let rate = remote.rate {
      request.rate = Int16(rate)
    }
    
    let attachedCustomer = fetchHandler.getUser(byId: remote.customerId, context: context)
    let attachedProvider = fetchHandler.getUser(byId: remote.providerId, context: context)

    if let customer = attachedCustomer {
      request.customer = customer
      customer.addToCustomerRequests(request)
    }
    
    request.provider = attachedProvider
    attachedProvider?.addToProviderRequests(request)

    let providerService = fetchHandler.getProviderService(by: remote.providerService.id, context: context)
    let generalService = fetchHandler.getService(by: remote.providerService.service.id, context: context)
    
    request.providerService = providerService
    request.service = generalService
    
    providerService?.addToRequest(request)
    generalService?.addToRequest(request)
  }
  
  func build(providerService: ProviderService, _ remote: RemoteProviderService, context: NSManagedObjectContext) {
    providerService.id = Int16(remote.id)
    providerService.addressId = Int16(remote.address.id)
    providerService.providerId = Int32(remote.providerId)
    providerService.serviceId = Int16(remote.service.id)
    providerService.price = remote.price
    providerService.serviceDescription = remote.description
    providerService.duration = remote.interval
    providerService.name = remote.name
    
    let generalService = fetchHandler.getService(by: remote.service.id, context: context)
    
    if let provider = fetchHandler.getUser(byId: Int(providerService.providerId), context: context) {
      providerService.provider = provider
      provider.addToProviderService(providerService)
    }
    
    providerService.service = generalService
    generalService?.addToProviderService(providerService)
  }
}
