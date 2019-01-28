//
//  PopOverViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class PopOverViewController<Element: PrintableObject>: UITableViewController {
  
  typealias SelectionHandler = (Element) -> Void
  
  private let values: [Element]
  private let onSelect: SelectionHandler?
  
  init(values: [Element], onSelect: @escaping SelectionHandler) {
    self.values = values
    self.onSelect = onSelect
    super.init(style: .plain)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return values.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.textLabel?.text = values[indexPath.row].getViewableString()
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.dismiss(animated: true)
    onSelect?(values[indexPath.row])
  }
  
}
