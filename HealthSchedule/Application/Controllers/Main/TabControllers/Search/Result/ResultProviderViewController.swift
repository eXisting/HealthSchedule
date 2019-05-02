//
//  ResultProviderViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr
import CDAlertView
import NVActivityIndicatorView

class ResultProviderViewController: UIViewController, NVActivityIndicatorViewable {
  private let titleName = "Chosen provider services"
  
  private let mainView = ChosenProviderView()
  private var model: ChosenProviderModel!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  convenience init(providerId: Int, serviceId: Int, time: Date) {
    self.init()
    model = ChosenProviderModel(errorDelegate: self, loaderDelegate: self, providerId, serviceId, time)
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(delegate: self, dataSource: model.dataSource)
    
    model.loadServices(completionHandler)
    
    setupNavigationItem()
  }
  
  private func setupNavigationItem() {
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationItem.title = titleName
  }
  
  private func completionHandler() {
    DispatchQueue.main.async {
      self.mainView.reloadTableView()
      self.stopAnimating()
    }
  }
}

extension ResultProviderViewController: LoaderShowable {
  func showLoader() {
    startAnimating(
      CGSize(width: view.frame.width / 2, height: view.frame.height * 0.25),
      message: "Refreshing...",
      type: .ballPulse,
      color: .white,
      padding: 30
    )
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: { [weak self] in
      if self!.isAnimating {
        self?.stopAnimating()
      }
    })
  }
  
  func hideLoader() {
    stopAnimating()
  }
}

extension ResultProviderViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension ResultProviderViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height * 0.15
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = ProviderServiceDetailViewController(model[indexPath.row], model.time)
    customPresentViewController(mainView.presenter, viewController: controller, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 10
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
}
