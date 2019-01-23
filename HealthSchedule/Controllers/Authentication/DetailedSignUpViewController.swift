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
  
  private var experienceAddedCounter = 0
  private var rootNaviationController: RootNavigationController?
  
  private var experienceBlocks: [SelectWithExperienceView]
  private var addMoreExperienceButton: UIButton
  
  required init?(coder aDecoder: NSCoder) {
    experienceBlocks = []
    addMoreExperienceButton = UIButton()
    
    super.init(coder: aDecoder)
    
    rootNaviationController = self.navigationController as? RootNavigationController
    loadViewsFromXib()
  }
  
  override func viewDidLoad() {
    if experienceBlocks.count > 0 {
      laidOutExperienceView(experienceBlocks[experienceAddedCounter])
    }
    
    laidOutAddButton()
  }
  
  @IBAction func onUserTypeChanged(_ sender: UISegmentedControl) {
    toogleProviderViews(!(sender.selectedSegmentIndex == AccountType.Provider.rawValue))
  }
  
  private func toogleProviderViews(_ state: Bool) {
      providerViewsContainer.isHidden = state
  }
}

// Experience views staff
private extension DetailedSignUpViewController {
  func loadViewsFromXib() {
    for _ in 0..<(rootNaviationController?.maxExperienceCount ?? 3) {
      experienceBlocks.append(SelectWithExperienceView.instanceFromNib() as! SelectWithExperienceView)
    }
  }
  
  func laidOutExperienceView(_ view: UIView!) {
    view.translatesAutoresizingMaskIntoConstraints = false
    experienceFieldsContiner.addArrangedSubview(view)
    
    NSLayoutConstraint(item: view, attribute: .width,
                       relatedBy: .equal,
                       toItem: experienceFieldsContiner,
                       attribute: .width,
                       multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: view, attribute: .height,
                       relatedBy: .equal,
                       toItem: self.view,
                       attribute: .height,
                       multiplier: 0.15,
                       constant: 0).isActive = true
    
    if experienceAddedCounter > 0 {
      laidOutRemoveButtonOn(view)
    }
    
    experienceAddedCounter += 1
  }
}

// Controls of experience views
private extension DetailedSignUpViewController {
  func laidOutAddButton() {
    addMoreExperienceButton.translatesAutoresizingMaskIntoConstraints = false
    experienceFieldsContiner.addArrangedSubview(addMoreExperienceButton)
    addMoreExperienceButton.backgroundImage(for: .normal)
    addMoreExperienceButton.setImage( UIImage.init(named: "Icons/plus"), for: .normal)
    
    NSLayoutConstraint(item: addMoreExperienceButton,
                       attribute: .width,
                       relatedBy: .equal,
                       toItem: experienceFieldsContiner,
                       attribute: .width,
                       multiplier: 0.15,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: addMoreExperienceButton,
                       attribute: .height,
                       relatedBy: .equal,
                       toItem: self.view,
                       attribute: .height,
                       multiplier: 0.08,
                       constant: 0).isActive = true
    
    addMoreExperienceButton.addTarget(self, action: #selector(onAddMoreExperienceButtonClick), for: .touchUpInside)
  }
  
  @objc func onAddMoreExperienceButtonClick(sender: UIButton!) {
    if experienceAddedCounter < rootNaviationController?.maxExperienceCount ?? 3 {
      laidOutExperienceView(experienceBlocks[experienceAddedCounter])
      
      // Append add button to the end of stack view
      experienceFieldsContiner.removeArrangedSubview(addMoreExperienceButton)
      addMoreExperienceButton.removeFromSuperview()
      laidOutAddButton()
    }
  }
  
  func laidOutRemoveButtonOn(_ view: UIView) {
    let removeButton = UIButton()
    removeButton.translatesAutoresizingMaskIntoConstraints = false
    experienceFieldsContiner.addSubview(removeButton)
    
    removeButton.backgroundImage(for: .normal)
    removeButton.setImage( UIImage.init(named: "Icons/minus"), for: .normal)
        
    NSLayoutConstraint(item: removeButton,
                       attribute: .width,
                       relatedBy: .equal,
                       toItem: view,
                       attribute: .width,
                       multiplier: 0.05,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: removeButton,
                       attribute: .height,
                       relatedBy: .equal,
                       toItem: view,
                       attribute: .height,
                       multiplier: 0.15,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: removeButton,
                       attribute: .bottom,
                       relatedBy: .equal,
                       toItem: view,
                       attribute: .bottom,
                       multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: removeButton,
                       attribute: .left,
                       relatedBy: .equal,
                       toItem: view,
                       attribute: .left,
                       multiplier: 1,
                       constant: 0).isActive = true
    
    removeButton.addTarget(self, action: #selector(onRemoveExperienceButtonClick), for: .touchUpInside)
  }
  
  @objc func onRemoveExperienceButtonClick(sender: UIButton) {
    print("Remove button tapped")
//    let choosenExperience = sender.superview!
//    // Append add button to the end of stack view
//    experienceFieldsContiner.removeArrangedSubview(choosenExperience)
//    choosenExperience.removeFromSuperview()
  }
}
