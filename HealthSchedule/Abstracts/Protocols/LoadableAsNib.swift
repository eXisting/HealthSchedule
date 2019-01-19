//
//  LoadableAsNib.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 1/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol LoadableAsNib {
    static func instanceFromNib<T: UIView>() -> T
}
