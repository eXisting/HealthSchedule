//
//  ScheduleViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr
import JZCalendarWeekView

protocol ScheduleNavigationItemDelegate {
  func save()
}

protocol ScheduleEventHandling {
  func updateAddEvent(event: DefaultEvent)
}

class ScheduleViewController: UIViewController {
  private let titleName = "Schedule template"

  @IBOutlet weak var calendarWeekView: JZLongPressWeekView!
  private let model = ScheduleModel()
  
  let presenter: Presentr = {
    let customType = PresentationType.popup
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .crossDissolve
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    return customPresenter
  }()
  
  private var customNavigationItem: ScheduleNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = ScheduleNavigationItem(title: titleName, delegate: model)
      }
      
      return customNavigationItem!
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBasic()
    setupCalendarView()
    setupNaviBar()
  }
    
  // Support device orientation change
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
  }
    
  private func setupCalendarView() {
    calendarWeekView.baseDelegate = self
  
    let monday = Date.today().previous(.monday)
    let saturday = Date.today().next(.saturday)
    let scrollableRange: (Date?, Date?) = (startDate: monday, endDate: saturday)
    
    calendarWeekView.setupCalendar(numOfDays: 7,
                                     setDate: Date(),
                                     allEvents: model.eventsByDate,
                                     scrollType: .pageScroll,
                                     scrollableRange: scrollableRange)
    
    // LongPress delegate, datasorce and type setup
    calendarWeekView.longPressDelegate = self
    calendarWeekView.longPressDataSource = self
    calendarWeekView.longPressTypes = [.addNew, .custom]
    
    // Optional
    calendarWeekView.addNewDurationMins = 120
    calendarWeekView.moveTimeMinInterval = 15
  }

  func setupBasic() {
    // Add this to fix lower than iOS11 problems
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  private func setupNaviBar() {
    updateNaviBarTitle()
  }
  
  private func updateNaviBarTitle() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM YYYY"
    self.navigationItem.title = dateFormatter.string(from: calendarWeekView.initDate.add(component: .day, value: calendarWeekView.numOfDays))
  }
}

extension ScheduleViewController: JZBaseViewDelegate {
  func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
    updateNaviBarTitle()
  }
}

extension ScheduleViewController: ScheduleEventHandling {
  func updateAddEvent(event: DefaultEvent) {
    if model.eventsByDate[event.startDate.startOfDay] == nil {
      model.eventsByDate[event.startDate.startOfDay] = [DefaultEvent]()
    }
    
    model.events.append(event)
    model.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: model.events)
    calendarWeekView.forceReload(reloadEvents: model.eventsByDate)
  }
}

extension ScheduleViewController: JZLongPressViewDelegate, JZLongPressViewDataSource {
  
  func weekView(_ weekView: JZLongPressWeekView, didEndAddNewLongPressAt startDate: Date) {
    let controller = ScheduleEventModalController(startDate: startDate)
    controller.eventsDelegate = self
    customPresentViewController(presenter, viewController: controller, animated: true)
  }
  
  func weekView(_ weekView: JZLongPressWeekView, didBeginLongPressOn cell: JZLongPressEventCell) {
    // TODO: - Show alert about deletion or editing
  }
    
  func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
    let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventCell
    view.titleLabel.text = "Place event"
    return view
  }
}
