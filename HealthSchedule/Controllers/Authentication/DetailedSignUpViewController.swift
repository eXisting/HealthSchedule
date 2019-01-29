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
  
  @IBOutlet weak var providerViewsContainer: UIStackView!
  @IBOutlet weak var experienceFieldsContiner: UIStackView!
  @IBOutlet weak var location: UITextField!
  
  private var maxAddedOrDefualt = 3
  private var rootNaviationController: RootAuthNavigationController?
  
  private var experienceBlocks = [SelectWithExperienceView]()
  private var addMoreExperienceButton = UIButton()
  
  private var citiesList: [City]?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    rootNaviationController = self.navigationController as? RootAuthNavigationController
    maxAddedOrDefualt = rootNaviationController?.maxExperienceCount ?? 3
  }
  
  override func loadView() {
    super.loadView()
    loadViewsFromXib()
  }
  
  override func viewDidLoad() {
    if experienceBlocks.count > 0 {
      laidOutExperienceView(experienceBlocks.first!, at: 0)
    }
    
    laidOutAddButton()
  }
  
  @IBAction func onUserTypeChanged(_ sender: UISegmentedControl) {
    toogleProviderViews(!(sender.selectedSegmentIndex == AccountType.Provider.rawValue))
  }
  
  private func toogleProviderViews(_ state: Bool) {
      providerViewsContainer.isHidden = state
  }
  
  @IBAction func onDidBeginEditing(_ sender: Any) {
    //TODO: loader
    
    guard let _ = citiesList else {
      RequestManager.getListAsyncFor(type: City.self, from: Endpoints.allCities, nil) { [weak self] cities in
        self?.citiesList = cities
        
        DispatchQueue.main.async{
          self?.presentPopOver()
        }
      }
      
      return
    }
    
    presentPopOver()
  }
  
  private func presentPopOver() {
    guard let cities = citiesList else {
      return
    }
    
    let controller = PopOverViewController<City>.init(values: cities, onSelect: selectCityObserver)
    
    controller.modalPresentationStyle = .popover
    controller.preferredContentSize = CGSize(width: 300, height: 200)
    
    let presentationController = controller.presentationController as! UIPopoverPresentationController
    presentationController.sourceView = view
    presentationController.sourceRect = view.bounds
    presentationController.permittedArrowDirections = [.left, .right]
    
    present(controller, animated: true)
  }
  
  private func selectCityObserver(_ selectedItem: PrintableObject) {
    location.text = selectedItem.getViewableString()
  }
}

// Experience views staff
private extension DetailedSignUpViewController {
  func loadViewsFromXib() {
    for _ in 0..<maxAddedOrDefualt {
      let section: SelectWithExperienceView = UIView.instanceFromNib("SelectWithExperienceView")
      experienceBlocks.append(section)
    }
  }
  
  func laidOutExperienceView(_ view: SelectWithExperienceView!, at index: Int) {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    experienceFieldsContiner.insertArrangedSubview(view, at: index)
    
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
    
    if experienceFieldsContiner.arrangedSubviews.count - 1 > 0 {
      let removeButton = view.laidOutRemoveButton()
      removeButton.addTarget(self, action: #selector(onRemoveExperienceButtonClick), for: .touchUpInside)
    }
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
                       toItem: addMoreExperienceButton,
                       attribute: .width,
                       multiplier: 1,
                       constant: 0).isActive = true
    
    addMoreExperienceButton.addTarget(self, action: #selector(onAddMoreExperienceButtonClick), for: .touchUpInside)
  }
  
  func removeAddButton() {
    experienceFieldsContiner.removeArrangedSubview(addMoreExperienceButton)
    addMoreExperienceButton.removeFromSuperview()
  }
  
  @objc func onAddMoreExperienceButtonClick(sender: UIButton!) {
    let experienceAddedCount = experienceFieldsContiner.arrangedSubviews.count - 1
    
    if experienceAddedCount < maxAddedOrDefualt {
      laidOutExperienceView(experienceBlocks[experienceAddedCount], at: experienceAddedCount)
      
      if experienceFieldsContiner.arrangedSubviews.count - 1 >= maxAddedOrDefualt {
        removeAddButton()
      }
    }
  }
}

// MARK: - Remove button action
extension DetailedSignUpViewController {
  @objc func onRemoveExperienceButtonClick(sender: UIButton) {
//    print("Remove button tapped")
//    let choosenExperience = sender.superview!
//    // Append add button to the end of stack view
//    experienceFieldsContiner.removeArrangedSubview(choosenExperience)
//    choosenExperience.removeFromSuperview()
//    
//    if experienceFieldsContiner.arrangedSubviews.count - 1 < maxAddedOrDefualt {
//      removeAddButton()
//      laidOutAddButton()
//    }
//    
//    experienceFieldsContiner.setNeedsLayout()
  }
}
