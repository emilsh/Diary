//
//  WorkingHours.swift
//  Diary
//
//  Created by Emil Shafigin on 19/5/21.
//

import Foundation

class WorkingHours {
  let dayStartAt = 7
  let dayEndsAt = 21
  var hours: [WorkHour]
  
  init(for date: Date) {
    self.hours = []
    for hour in Range(dayStartAt...dayEndsAt) {
      let workHour = WorkHour(hour, for: date)
      hours.append(workHour)
    }
  }
}

class WorkHour {
  var hourInString: String
  var hourInterval: DateInterval
  let oneHour: TimeInterval = 3600
  var task: Task?
  
  init(_ hour: Int, for date: Date) {
    let secondsToDesiredHour = Double(hour) * oneHour
    let desiredHour = date.addingTimeInterval(secondsToDesiredHour)
    self.hourInterval = DateInterval(start: desiredHour, duration: oneHour)
    
    self.hourInString = "\(hour).00 - \(hour + 1).00"
  }
}
