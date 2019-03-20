//
//  RequestCardViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardViewController: UIViewController {
  private let mainView = RequestCardView()
  private let model = RequestCardModel()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(delegate: self, dataSource: model.dataSource)
  }
  
  func set(_ request: RemoteRequest) {
    title = request.providerService.service.title
    model.procceedRequest(request)
  }
}

extension RequestCardViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 55
  }
}
