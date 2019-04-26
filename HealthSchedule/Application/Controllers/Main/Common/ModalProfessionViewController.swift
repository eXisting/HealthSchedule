//
//  ModalProfessionViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/26/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ModalProfessionViewController: UITableViewController {
  var storeDelegate: ModalPickHandling!
  var list: [Profession] = []
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let city = list[indexPath.row]
    storeDelegate.picked(id: Int(city.id), title: city.name!, .profession)
    dismiss(animated: true)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = list[indexPath.row].name
    return cell
  }
}
