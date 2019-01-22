//
//  DetailedSignUpViewController.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 1/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum AccountType : Int {
  case Client = 0
  case Provider = 1
}

class DetailedSignUpViewController: UIViewController {
  
  @IBOutlet var providerViewsContainer: UIStackView!
  
  @IBOutlet weak var experienceFieldsContiner: UIStackView!
  
  @IBOutlet weak var experienceTextValue: UILabel!
  @IBOutlet weak var experiencePicker: UISlider!
  
  private var experienceBlocks: [SelectWithExperienceView]
  
  required init?(coder aDecoder: NSCoder) {
    experienceBlocks = []
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    experienceTextValue.text = "\(experiencePicker.value)"
    toogleProviderViews(true)
    
    let customView = SelectWithExperienceView.instanceFromNib() as! SelectWithExperienceView
    customView.expandPutViewTo(experienceFieldsContiner)
  }
  
  @IBAction func onUserTypeChanged(_ sender: UISegmentedControl) {
    toogleProviderViews(!(sender.selectedSegmentIndex == AccountType.Provider.rawValue))
  }
  
  @IBAction func onExperienceValueChanged(_ sender: UISlider) {
   experienceTextValue.text = "\(sender.value)"
  }
  
  private func toogleProviderViews(_ state: Bool) {
      providerViewsContainer.isHidden = state
  }
}
