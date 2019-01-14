//
//  HospitalsCollectionViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/10/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class BaseCollectionViewController: UICollectionViewController {
  
  // MARK: - Outlets
  
  // MARK: - Properties
  
  private let reuseIdentifier = "BaseContentViewCell"
  
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  
  private let itemsPerRow: CGFloat = 2
  
  // MARK: - Overrides
  
  
  override func viewDidLoad() {
    collectionView.register(UINib(nibName: "ContentViewCell", bundle: nil), forCellWithReuseIdentifier: "BaseContentViewCell")
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BaseUICollectionViewCell
    
    cell.backgroundColor = .white
    
    let backgroundImage = (RequestHandler.shared as ImageRequesting).getImage(from: "https://redhothealthcare-zone1-6mudibe7tedrrcg51wj.netdna-ssl.com/wp-content/uploads/2017/05/hospital.jpg")
    
    cell.previewImage.image = backgroundImage
    //cell.thumbnailImage = cell.backgroundImage?.image
    
    return cell
  }
}

// MARK: - Collection View Flow Layout Delegate

extension BaseCollectionViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
