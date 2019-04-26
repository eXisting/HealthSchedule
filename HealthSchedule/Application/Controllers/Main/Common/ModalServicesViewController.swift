//
//  ServicesModalController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ModalServicesViewController: UITableViewController {
  var storeDelegate: ModalPickHandling!
  var list: [Service] = []
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let service = list[indexPath.row]
    storeDelegate.picked(id: Int(service.id), title: service.name!, .service)
    dismiss(animated: true)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = list[indexPath.row].name
    return cell
  }
}
