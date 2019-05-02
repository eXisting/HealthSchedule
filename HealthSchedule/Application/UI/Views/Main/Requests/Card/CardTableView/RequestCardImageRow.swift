//
//  RequestCardRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/21/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import EasyPeasy

class RequestCardImageRow: UITableViewCell {
  private let photo = UIImageView()
  private var spinner = UIActivityIndicatorView(style: .whiteLarge)
  private let nameLabel = UILabel()
  
  var photoImage: UIImage? {
    return photo.image
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    laidOutViews()
    customizeViews()
    
    toggleSpinner()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func populateCell(name: String) {
    nameLabel.text = name
  }
  
  func setImage(_ image: UIImage) {
    photo.roundCorners(by: photo.frame.height / 2)
    
    toggleSpinner()
    
    UIView.transition(with: photo,
                      duration: 0.75,
                      options: .transitionCrossDissolve,
                      animations: { [weak self] in
                        self?.photo.image = image
                        self?.photo.makeCircleBorder(with: UIColor.black.cgColor, 1)
                      },
                      completion: nil)
  }
  
  private func laidOutViews() {
    addSubview(photo)
    addSubview(nameLabel)
    addSubview(spinner)
    
    spinner.translatesAutoresizingMaskIntoConstraints = false
    photo.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    photo.easy.layout([
      CenterY().to(self),
      Left(*0.15).to(self, .centerX),
      Width().like(photo, .height).with(.required),
      Height(*0.8).like(self).with(.required)
    ])
    
    nameLabel.easy.layout([
      CenterY().to(self),
      Right(*0.95).to(self),
      Left(==16).to(photo, .right)
    ])
    
    spinner.easy.layout([
      CenterX().to(photo, .centerX),
      CenterY().to(photo, .centerY),
      Height().like(photo, .height),
      Width().like(photo, .width)
    ])
  }
  
  private func customizeViews() {
    nameLabel.frame = nameLabel.frame.inset(by: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 8))
    nameLabel.textAlignment = .left
    nameLabel.adjustsFontSizeToFitWidth = true
    nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
    
    spinner.color = .black
    
    selectionStyle = .none
  }
  
  private func toggleSpinner() {
    if spinner.isAnimating {
      spinner.stopAnimating()
      spinner.removeFromSuperview()
    } else {
      spinner.startAnimating()
    }
  }
}
