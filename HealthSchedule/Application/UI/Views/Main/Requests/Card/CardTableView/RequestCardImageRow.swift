//
//  RequestCardRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/21/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardImageRow: UITableViewCell {
  private let container = UIStackView()
  
  private let photo = UIImageView()
  private let nameLabel = UILabel()
  
  var photoImage: UIImage? {
    get { return photo.image }
    set {
      UIView.transition(
        with: self.photo,
        duration: 0.3,
        options: .transitionCrossDissolve,
        animations: { self.photo.image = newValue },
        completion: nil
      )
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func populateCell(name: String) {
    nameLabel.text = name    
    photo.image = UIImage(named: "Pictures/chooseProfile")
  }
  
  private func laidOutViews() {
    addSubview(container)
    container.addArrangedSubview(photo)
    container.addArrangedSubview(nameLabel)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    photo.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: photo, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 0.4, constant: 0).isActive = true

    NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.8, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.9, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    container.alignment = .fill
    container.distribution = .fill
    container.axis = .horizontal
    
    photo.contentMode = .scaleAspectFit
    nameLabel.frame = nameLabel.frame.inset(by: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 8))
    
    nameLabel.adjustsFontSizeToFitWidth = true
    nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
    
    photo.roundCorners(by: photo.frame.height / 2)
    selectionStyle = .none
  }
}
