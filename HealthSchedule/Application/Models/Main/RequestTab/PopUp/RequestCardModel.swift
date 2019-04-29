//
//  RequestCardModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardModel {
  private let commmonDataRequestController = CommonDataRequest()
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
  
  func updateRequest(status: RequestStatusName) {
    let postData: Parser.JsonDictionary = [
      RequestJsonFields.status.rawValue: String(ReqeustStatus.statusName2RValue(value: status))
    ]
    
    requestManager.updateRequest(id: Int(request.id), with: postData) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        self?.errorDelegate.showWarningAlert(message: response)
      }
    }
  }
  
  subscript(forSectionIndex: Int) -> RequestSectionDataContaining {
    return source[forSectionIndex]
  }
  
  private func loadImage(by url: String, _ completion: @escaping (UIImage) -> Void) {
    let isRemoteImage = url.contains("http")
    
    commmonDataRequestController.getImage(from: url, isLaravelRelated: !isRemoteImage) { data in
      let displayImage = UIImage(named: "Pictures/chooseProfile")!
      
      guard let data = data else {
        completion(displayImage)
        return
      }
      
      guard let image = UIImage(data: data) else {
        completion(displayImage)
        return
      }
      
      completion(image)
    }
  }
}

extension RequestCardModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
