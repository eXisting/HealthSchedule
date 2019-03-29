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
  
  func buildBasicUserFields(for user: User, _ remoteUser: RemoteUser) {
    user.name = "\(remoteUser.firstName) \(remoteUser.lastName)"
    user.email = remoteUser.email
    user.phone = remoteUser.phone
    user.birthday = remoteUser.birthday
    
    user.id = Int32(remoteUser.id)
    user.roleId = Int16(remoteUser.role!.id)
    user.cityId = Int16(remoteUser.city!.id)
  }
  
  func buildBasicFields(for image: UserImage, with userId: Int32, _ remoteImage: ProfileImage) {
    image.id = Int32(remoteImage.id)
    image.url = remoteImage.url
    image.userId = userId
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

    request.providerService = providerService
    request.service = generalService
    
    providerService?.addToRequest(request)
    generalService?.addToRequest(request)
  }
  
  func build(providerService: ProviderService, _ remote: RemoteProviderService, context: NSManagedObjectContext) {
    providerService.id = Int16(remote.id)
    providerService.addressId = Int16(remote.address.id)
    providerService.providerId = Int16(remote.providerId)
    providerService.serviceId = Int16(remote.service.id)
    providerService.price = remote.price
    providerService.serviceDescription = remote.description
    
    let generalService = fetchHandler.getService(by: remote.service.id, context: context)
    
    providerService.service = generalService
    
    generalService?.addToProviderService(providerService)
  }
}
