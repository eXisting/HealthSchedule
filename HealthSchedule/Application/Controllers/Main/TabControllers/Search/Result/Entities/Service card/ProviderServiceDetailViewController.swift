//
//  ProviderServiceDetailViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

class ProviderServiceDetailViewController: UIViewController, NVActivityIndicatorViewable {
  private let mainView = SendRequestView()
  private var model: ChosenProviderServiceModel!
  
  convenience init(_ service: ProviderService, _ time: Date) {
    self.init()
    model = ChosenProviderServiceModel(errorDelegate: self, loaderDelegate: self, service, time)
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(delegate: self, dataSource: model.dataSource, action: sendRequest)
  }
  
  private func sendRequest() {
    model.sendRequest()
  }
}

extension ProviderServiceDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height * 0.1
  }
}

extension ProviderServiceDetailViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension ProviderServiceDetailViewController: LoaderShowable {
  func showLoader() {
    let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
    startAnimating(size, type: .ballClipRotate, color: .white, backgroundColor: UIColor.black.withAlphaComponent(0.75))
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: { [weak self] in
      if self!.isAnimating {
        self?.stopAnimating()
      }
    })
  }
  
  func hideLoader() {
    stopAnimating()
  }
}
