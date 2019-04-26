//
//  TemplateScheduleWeekView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr
import JZCalendarWeekView

class TemplateScheduleWeekView: JZLongPressWeekView {
  lazy var presenter: Presentr = {
    let customType = PresentationType.popup
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .crossDissolve
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    customPresenter.cornerRadius = 10
    return customPresenter
  }()
  
  override func registerViewClasses() {
    super.registerViewClasses()
    
    self.collectionView.register(UINib(nibName: LongPressEventCell.className, bundle: nil), forCellWithReuseIdentifier: LongPressEventCell.className)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LongPressEventCell.className, for: indexPath) as! LongPressEventCell
    cell.configureCell(event: getCurrentEvent(with: indexPath) as! DefaultEvent)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
  }
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedEvent = getCurrentEvent(with: indexPath) as! DefaultEvent
    ToastUtil.toastMessageInTheMiddle(message: selectedEvent.status ? "Working range" : "Off range")
  }
}
