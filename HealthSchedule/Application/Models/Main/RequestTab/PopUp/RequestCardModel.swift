//
//  RequestCardModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardModel {
  private let commonDataRequestController = CommonDataRequest()
  private let requestManager: UserDataUpdating = UserDataRequest()
  
  private var request: Request
  private var errorDelegate: ErrorShowable
  private var source: RequestCardDataSource!
  
  init(request: Request, errorDelegate: ErrorShowable) {
    self.request = request
    self.errorDelegate = errorDelegate
    
    source = RequestCardDataSource(request, imageLoader: loadImage, errorDelegate: errorDelegate)
    source.imageProcessing = loadImage
  }
  
  func getActionsCount() -> Int {
    let requestStatus = ReqeustStatus.statusValue2RequestStatusName(value: Int(request.status))
    
    if requestStatus == .pending {
      return 2
    } else if requestStatus == .accepted {
      return 1
    }
    
    return 0
  }
  
  func getCurrentUserRole() -> Role {
    guard let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      fatalError("Cannot get user from Core Data while being logged in...")
    }
    
    guard let role = user.role else { fatalError("App user must have a role attached to him!") }
    
    return role
  }
  
  func updateRequest(status: RequestStatusName, _ completion: @escaping () -> Void) {
    let postData: Parser.JsonDictionary = [
      RequestJsonFields.status.rawValue: String(ReqeustStatus.statusName2RValue(value: status))
    ]
    
    requestManager.updateRequest(id: Int(request.id), with: postData) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.errorDelegate.showWarningAlert(message: response)          
        }
        
        return
      }
      
      completion()
    }
  }
  
  subscript(forSectionIndex: Int) -> RequestSectionDataContaining {
    return source[forSectionIndex]
  }
  
  private func loadImage(by url: String?, _ completion: @escaping (UIImage) -> Void) {
    let defaultImage = UIImage(named: "Pictures/chooseProfile")!
    
    guard let url = url else {
      completion(defaultImage)
      return
    }
    
    let isRemoteImage = url.contains("http")
    
    if let cachedImage = CacheManager.shared.getFromCache(by: url as AnyObject) as? UIImage {
      completion(cachedImage)
      return
    }
    
    commonDataRequestController.getImage(from: url, isLaravelRelated: !isRemoteImage) { data in
      guard let data = data else {
        completion(defaultImage)
        return
      }
      
      guard let image = UIImage(data: data) else {
        completion(defaultImage)
        return
      }
      
      CacheManager.shared.saveToCache(url as AnyObject, image)
      completion(image)
    }
  }
}

extension RequestCardModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
