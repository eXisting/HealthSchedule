//
//  ScheduleTemplateCollectionView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ScheduleTemplateCollectionView: UICollectionView {
  func setupCollectionView(
    delegate: UICollectionViewDelegate,
    dataSource: UICollectionViewDataSource,
    layout: UICollectionViewFlowLayout) {
    
    self.delegate = delegate
    self.dataSource = dataSource
    collectionViewLayout = layout
  }
}
