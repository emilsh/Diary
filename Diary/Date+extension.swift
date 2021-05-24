//
//  Date+extension.swift
//  Diary
//
//  Created by Emil Shafigin on 21/5/21.
//

import Foundation

extension Date {
  func extractYearMonthDayFromDate() -> Date? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: self)
    guard let date = calendar.date(from: components) else { return nil }
    return date
  }
}

extension DateInterval {
  init(start: TimeInterval, finish: TimeInterval) {
    if start < finish {
      let startDate = Date(timeIntervalSince1970: start)
      let endDate = Date(timeIntervalSince1970: finish)
      self.init(start: startDate, end: endDate)
    } else {
      self.init()
    }
  }
}

extension TimeInterval {
  func timeFromTimeInterval() -> String {
    let date = Date(timeIntervalSince1970: self)
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: date)
    guard let hour = components.hour,
          let minute = components.minute else { return "" }
    var minuteStr = ""
    switch minute {
    case 0:
      minuteStr = "00"
    case 1,2,3,4,5,6,7,8,9:
      minuteStr = "0\(minute)"
    default:
      minuteStr = "\(minute)"
    }
    
    return "\(hour):\(minuteStr)"
  }
}
