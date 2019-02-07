//
//  AdditionalInfoSignUpController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AdditionalInfoSignUpController: UIViewController, UITextFieldDelegate {
  
  private var mainView: DetailedinfoMainView!
  private var citiesPopOver: PopOverViewController<City>?
  
  private var selectedCityId: Int!
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! DetailedinfoMainView)
    mainView.setupViews()
    
    addTargets()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.cityPicker.delegate = self
  }
  
  private func collectData() {
    self.navigationController?.viewControllers.forEach { controller in
      guard let rootSignUpController = controller as? SignUpRootViewController else {
        return
      }
      
      rootSignUpController.signUpData[UserJsonFields.cityId.rawValue] = String(selectedCityId)
      rootSignUpController.signUpData[UserJsonFields.birthday.rawValue] = DatesManager.shared.dateToString(mainView.birthdayPicker.date)
    }
  }
  
  private func openApplication() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateInitialViewController() as! UITabBarController
    
    self.present(controller, animated: true, completion: nil)
  }
  
  private func toogleStepButtons() {
    if selectedCityId != nil {
      let userType = UserType(rawValue: mainView.userPicker.selectedSegmentIndex + 1)
      mainView.setDoneButtonVisible(userType == .provider ? false : true)
      mainView.setNextButtonVisible(userType == .provider ? true : false)
    }
  }
  
  // MARK: - Selectors
  
  @objc func onDoneButtonClick() {
    collectData()
    openApplication()
  }
  
  @objc func onNextButtonClick() {
    collectData()
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProviderSignUp") as! ProviderSignUpViewController
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func onUserChanged() {
    toogleStepButtons()
  }
  
  @objc func onStartSelectCity(_ sender: Any) {
    toggleCityPickerSelectAction(enabled: false)
    
    guard let _ = citiesPopOver?.values else {
      RequestManager.getListAsync(for: City.self, from: Endpoints.allCities, nil) { [weak self] (cities, status) in
        self?.citiesPopOver = PopOverViewController(values: cities, onSelect: (self?.onCitySelect)!)
        
        DispatchQueue.main.async {
          self?.presentPopOver()
        }
      }
      
      return
    }
    
    presentPopOver()
  }
  
  // MARK: - UITextFieldDelegate
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return false
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    mainView.setNextButtonVisible(mainView.isCityFieldEmpty() ? false : true)
  }
  
  // MARK: - Present pop over stuff
  
  private func presentPopOver() {
    guard let _ = citiesPopOver?.values,
      let popOver = citiesPopOver else {
      return
    }
    
    popOver.modalPresentationStyle = .popover
    
    let presentationController = popOver.presentationController as! UIPopoverPresentationController
    presentationController.sourceView = view
    presentationController.sourceRect = view.bounds
    presentationController.permittedArrowDirections = [.left, .right]
    
    self.navigationController?.pushViewController(popOver, animated: true)
    toggleCityPickerSelectAction(enabled: true)
  }
  
  private func onCitySelect(_ selectedItem: City) {
    mainView.cityPicker.text = selectedItem.title
    selectedCityId = selectedItem.id
    
    toogleStepButtons()

    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - View setup
  
  private func addTargets() {
    mainView.nextButton.addTarget(self, action: #selector(onNextButtonClick), for: .touchDown)
    mainView.doneButton.addTarget(self, action: #selector(onDoneButtonClick), for: .touchDown)
    mainView.userPicker.addTarget(self, action: #selector(onUserChanged), for: .valueChanged)
    toggleCityPickerSelectAction(enabled: true)
  }
  
  private func toggleCityPickerSelectAction(enabled: Bool) {
    if enabled {
      mainView.cityPicker.addTarget(self, action: #selector(onStartSelectCity), for: .touchDown)
    } else {
      mainView.cityPicker.removeTarget(nil, action: nil, for: .touchDown)
    }
  }
}
