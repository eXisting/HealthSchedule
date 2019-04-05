//
//  ProviderServiceRowModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ProviderServiceRowDataContaining {
  var data: String { get }
  var title: String { get }
  var rowHeight: CGFloat { get }
}

class ProviderServiceTextRowModel: ProviderServiceRowDataContaining {
  var data: String = ""
  var title: String
  var rowHeight: CGFloat = 65
  
  init(title: String) {
    self.title = title
  }
}

class ProviderServiceDateRowModel: ProviderServiceRowDataContaining {
  var data: String = ""
  var title: String = "Duration:"
  var imageUrl: String?
  var rowHeight: CGFloat = 65
}

