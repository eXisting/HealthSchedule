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
import NVActivityIndicatorView

protocol ScheduleNavigationItemDelegate {
  func save()
}

protocol ScheduleEventHandling {
  func updateAddEvent(event: DefaultEvent)
}

protocol ScheduleEventsRefreshing {
  func refresh()
}

class ScheduleViewController: UIViewController, NVActivityIndicatorViewable {
  private let titleName = "Schedule template"

  @IBOutlet weak var calendarWeekView: TemplateScheduleWeekView!
  private let model = ScheduleModel()
  
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
    model.delegate = self
    
    setupBasic()
    setupCalendarView()
    setupNaviBar()
    
    startLoadTemplates()
  }
    
  // Support device orientation change
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    JZWeekViewHelper.viewTransitionHandler(to: size, weekView: calendarWeekView)
  }
  
  private func setupCalendarView() {
    calendarWeekView.baseDelegate = self
  
    let monday = Date.today().currentWeekMonday
    let saturday = Date.today().next(.saturday, considerToday: true)
    let scrollableRange: (Date?, Date?) = (startDate: monday, endDate: saturday)
    
    calendarWeekView.setupCalendar(numOfDays: 7,
                                     setDate: Date(),
                                     allEvents: model.eventsByDate,
                                     scrollType: .sectionScroll,
                                     firstDayOfWeek: .Monday,
                                     scrollableRange: scrollableRange)
    
    // LongPress delegate, datasorce and type setup
    calendarWeekView.longPressDelegate = self
    calendarWeekView.longPressDataSource = self
    calendarWeekView.longPressTypes = [.addNew, .custom]
    
    // Optional
    calendarWeekView.addNewDurationMins = 120
    calendarWeekView.moveTimeMinInterval = 15
  }

  private func setupBasic() {
    // Add this to fix lower than iOS11 problems
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  private func startLoadTemplates() {
    if model.eventsByDate.isEmpty {
      let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
      startAnimating(size, type: .ballScaleRippleMultiple, color: .white, displayTimeThreshold: 5, minimumDisplayTime: 2)
    }
    
    DispatchQueue.global(qos: .background).async {
      self.model.loadFromCoreData()
    }
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

extension ScheduleViewController: ScheduleEventsRefreshing {
  func refresh() {
    calendarWeekView.forceReload(reloadEvents: model.eventsByDate)
    
    if self.isAnimating {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.stopAnimating()
      }
    }
  }
}

extension ScheduleViewController: ScheduleEventHandling {
  func updateAddEvent(event: DefaultEvent) {
    model.insertUpdateEvent(event)
    model.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: model.events)
    refresh()
  }
}

extension ScheduleViewController: JZLongPressViewDelegate, JZLongPressViewDataSource {
  
  func weekView(_ weekView: JZLongPressWeekView, didEndAddNewLongPressAt startDate: Date) {
    let controller = ScheduleEventModalController(startDate: startDate)
    controller.eventsDelegate = self
    customPresentViewController(calendarWeekView.presenter, viewController: controller, animated: true)
  }
  
  func weekView(_ weekView: JZLongPressWeekView, didBeginLongPressOn cell: JZLongPressEventCell) {
    let event = cell.event as! DefaultEvent
    let controller = ScheduleEventModalController(
      startDate: event.startDate,
      endDate: event.endDate,
      status: event.status ? .working : .off
    )
    
    controller.eventsDelegate = self
    customPresentViewController(calendarWeekView.presenter, viewController: controller, animated: true)
  }
    
  func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
    let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventCell
    view.titleLabel.text = "Place event"
    return view
  }
}
