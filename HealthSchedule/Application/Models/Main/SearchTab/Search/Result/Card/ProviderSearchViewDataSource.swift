//
//  ProviderSearchViewDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/18/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import EasyPeasy

class ProviderSearchViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  var userPhotoData: String?
  var data: [Any] = []
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCardImageRow") as! RequestCardImageRow
      cell.populateCell(name: data[indexPath.row] as! String)
//      print(data[indexPath.row])
      cell.backgroundColor = .clear
      return cell
    }
    
    let cell = UITableViewCell()
    cell.backgroundColor = .clear
    cell.textLabel?.text = data[indexPath.row] as! String
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 85
    }
    
    return 60
  }
}
