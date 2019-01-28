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
  private var rootNaviationController: RootNavigationController?
  
  private var experienceBlocks = [SelectWithExperienceView]()
  private var addMoreExperienceButton = UIButton()
  
  private let request: ListsRequesting! = RequestHandler()
  
  // Remote data
  private var citiesList: [City]?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    rootNaviationController = self.navigationController as? RootNavigationController
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
    // TODO: refactor this
    
    request.getAsync(from: "http://127.0.0.1:8000/api/cities") { [weak self] cities in
      if cities.count == 0 {
        AlertHandler.ShowAlert(for: self!, "Error!", "Cannot load list of cities!", .alert)
        return
      }
      DispatchQueue.main.async{
        var citiesTitles = [String]()
        self?.citiesList = []
        
        for jsonCity in cities {
          guard let city = jsonCity as? [String:Any] else {
            print("Cannot cast to [String:Any]")
            continue
          }
          
          guard let cityObject = City(json: city) else {
            continue
          }
          
          citiesTitles.append(cityObject.title)
          self?.citiesList?.append(cityObject)
        }
        
        let controller = PopOverViewController<City>.init(values: (self?.citiesList)!, onSelect: (self?.selectCityObserver)!)
        
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        presentationController.sourceView = self?.view
        presentationController.sourceRect = self?.view?.bounds ?? .zero
        presentationController.permittedArrowDirections = [.left, .right]
        
        self?.present(controller, animated: true)
      }
    }
    
    // loader
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
