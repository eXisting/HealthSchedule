//
//  ScheduleViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import JZCalendarWeekView

protocol ScheduleNavigationItemDelegate {
  func save()
}

class ScheduleViewController: UIViewController {
        
  @IBOutlet weak var calendarWeekView: JZLongPressWeekView!
  let model = ScheduleModel()
    
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

extension ScheduleViewController: JZLongPressViewDelegate, JZLongPressViewDataSource {
    
  func weekView(_ weekView: JZLongPressWeekView, didEndAddNewLongPressAt startDate: Date) {
    let newEvent = DefaultEvent(id: UUID().uuidString, title: "New Event", startDate: startDate, endDate: startDate.add(component: .hour, value: weekView.addNewDurationMins/60),
                         location: "Melbourne")
    
    if model.eventsByDate[startDate.startOfDay] == nil {
        model.eventsByDate[startDate.startOfDay] = [DefaultEvent]()
    }
    model.events.append(newEvent)
    model.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: model.events)
    weekView.forceReload(reloadEvents: model.eventsByDate)
  }
    
  func weekView(_ weekView: JZLongPressWeekView, editingEvent: JZBaseEvent, didEndMoveLongPressAt startDate: Date) {
    let event = editingEvent as! DefaultEvent
    let duration = Calendar.current.dateComponents([.minute], from: event.startDate, to: event.endDate).minute!
    let selectedIndex = model.events.index(where: { $0.id == event.id })!
    model.events[selectedIndex].startDate = startDate
    model.events[selectedIndex].endDate = startDate.add(component: .minute, value: duration)
    
    model.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: model.events)
    weekView.forceReload(reloadEvents: model.eventsByDate)
  }
  
  func weekView(_ weekView: JZLongPressWeekView, didBeginLongPressOn cell: JZLongPressEventCell) {
    AlertHandler.ShowAlert(for: self, "Yohooo", "Worked", .alert)
  }
    
  func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
    let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventCell
    view.titleLabel.text = "New Event"
    return view
  }
}

extension ScheduleViewController: ScheduleNavigationItemDelegate {
  func save() {
    model.loadProviderScheduleTemplate {
      
    }
  }
}
