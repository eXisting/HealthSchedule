//
//  CityViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit


class ModalCityViewController: UITableViewController {
  var storeDelegate: CityPickHandling!
  var cititesList: [City] = []
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cititesList.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    storeDelegate.picked(id: Int(cititesList[indexPath.row].id))
    dismiss(animated: true)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = cititesList[indexPath.row].name
    return cell
  }
}
