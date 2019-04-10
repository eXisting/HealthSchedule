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
      
      let city = fetchHandler.getCtiy(byId: Int(user.cityId), context: context)
      city?.addToUser(user)
      user.city = city
    }
    
    if let role = remoteUser.role {
      user.roleId = Int16(role.id)
    } else {
      user.roleId = Int16(4) // magic number
    }
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
  
  func build(service: Service, _ remoteService: RemoteService) {
    service.id = Int16(remoteService.id)
    service.name = remoteService.title
  }
  
  func build(request: Request, _ remote: RemoteRequest, context: NSManagedObjectContext) {
    request.id = Int16(remote.id)
    request.requestDescription = remote.description
    request.requestedAt = remote.requestAt
    request.status = Int16(remote.status.value)
    request.userId = Int16(remote.userId)
    request.serviceId = Int16(remote.providerService.service.id)
    
    if let rate = remote.rate {
      request.rate = Int16(rate)
    }
    
    let providerService = fetchHandler.getProviderService(by: remote.providerService.id, context: context)
    let generalService = fetchHandler.getService(by: remote.providerService.service.id, context: context)
    let attachedUser = fetchHandler.getUser(byId: remote.userId, context: context)

    request.providerService = providerService
    request.service = generalService
    request.user = attachedUser

    providerService?.addToRequest(request)
    generalService?.addToRequest(request)
    attachedUser?.addToRequest(request)
  }
  
  func build(providerService: ProviderService, _ remote: RemoteProviderService, context: NSManagedObjectContext) {
    providerService.id = Int16(remote.id)
    providerService.addressId = Int16(remote.address.id)
    providerService.providerId = Int16(remote.providerId)
    providerService.serviceId = Int16(remote.service.id)
    providerService.price = remote.price
    providerService.serviceDescription = remote.description
    providerService.duration = remote.interval
    
    let generalService = fetchHandler.getService(by: remote.service.id, context: context)
    let provider = fetchHandler.getUser(byId: Int(providerService.providerId), context: context)
    
    providerService.service = generalService
    providerService.provider = provider
    
    generalService?.addToProviderService(providerService)
    provider?.addToProviderService(providerService)
  }
}
