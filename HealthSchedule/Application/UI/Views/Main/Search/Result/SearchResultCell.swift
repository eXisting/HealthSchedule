//
//  SearchResultCelll.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FoldingCell
import EasyPeasy

class SearchResultFoldingCell: FoldingCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    containerView = createContainerView()
    foregroundView = createForegroundView()
    
    // super class method configure views
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
    
    // durations count equal it itemCount
    let durations = [0.33, 0.26, 0.26] // timing animation for each view
    return durations[itemIndex]
  }
}

// MARK: Configure
extension SearchResultFoldingCell {
  
  private func createForegroundView() -> RotatedView {
    let foregroundView = Init(value: RotatedView(frame: .zero)) {
      $0.backgroundColor = .red
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    contentView.addSubview(foregroundView)
    
    foregroundView.easy.layout([
      Height(75),
      Left(8),
      Right(8)
    ])
    
    // add identifier
    let top = foregroundView.easy.layout([Top(8)]).first
    top?.identifier = "ForegroundViewTop"
    
    foregroundViewTop = top
    
    foregroundView.layoutIfNeeded()
    
    return foregroundView
  }
  
  private func createContainerView() -> UIView {
    let containerView = Init(value: UIView(frame: .zero)) {
      $0.backgroundColor = .green
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    contentView.addSubview(containerView)
    
    // add constraints
    containerView.easy.layout([
      Height(CGFloat(75 * itemCount)),
      Left(8),
      Right(8)
    ])
    
    // add identifier
    let top = containerView.easy.layout([Top(8)]).first
    top?.identifier = "ContainerViewTop"
    
    containerViewTop = top
    
    containerView.layoutIfNeeded()
    
    return containerView
  }
}


internal func Init<Type>(value : Type, block: @escaping (_ object: Type) -> Void) -> Type
{
  block(value)
  return value
}
