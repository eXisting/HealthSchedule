//
//  ExpertsCollectionViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ExpertsCollectionViewController: UICollectionViewController {
  
  // MARK: - Outlets
  
  // MARK: - Properties
  
  private let reuseIdentifier = "BaseContentViewCell"
  
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  
  private let itemsPerRow: CGFloat = 3
  
  private var experts = [ExpertProfile]()
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    collectionView.register(
      UINib(nibName: "ContentViewCell",bundle: nil),
      forCellWithReuseIdentifier: "BaseContentViewCell")
    
    RequestHandler.shared.getAsync(from: RequestHandler.buildEndPointUrl(), complition: { json in
      let _ = json.map { [weak self] profile in
        
        guard let jsonData = profile as? [String: Any],
          var expert = ExpertProfile(json: jsonData) else {
          print("Cannot populate expert")
          return
        }
        
        // TODO: Not working
//        RequestHandler.shared.getImageAsync(from:
//          expert.pictureUrls?[ProfileJsonFields.thumbnail.rawValue] as! String) { image in
//          expert.setActiveImage(image)
//        }
        expert.setActiveImage(RequestHandler.shared.getImage(from: expert.pictureUrls?[ProfileJsonFields.thumbnail.rawValue] as! String))
        self?.experts.append(expert)
      }
      
      print("Controller called")
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    })
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BaseUICollectionViewCell
    
    //cell.backgroundColor = .white
    if indexPath.row < experts.count {
      let expert = experts[indexPath.row]
      cell.fullName.text = "\(expert.firstName) \(expert.lastName)"
      cell.fullDescription.text = expert.location
      
      //let backgroundImage = (RequestHandler.shared as ImageRequesting).getImage(from: "https://seowatch.ru/images/seo-expert.png")
      cell.previewImage.image = expert.profilePhoto
    }
    
    return cell
  }
}

// MARK: - Collection View Flow Layout Delegate

extension ExpertsCollectionViewController : UICollectionViewDelegateFlowLayout {
  
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

