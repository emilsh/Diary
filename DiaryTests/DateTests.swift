//
//  DateTests.swift
//  DiaryTests
//
//  Created by Emil Shafigin on 21/5/21.
//

import XCTest
@testable import Diary

class DateTests: XCTestCase {
  
  func testExtractionOfYearMonthDayFromDate() {
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = 2021
    components.month = 5
    components.day = 20
    components.hour = 21
    components.minute = 15
    components.timeZone = TimeZone.current
    let date = calendar.date(from: components)?.extractYearMonthDayFromDate()
    
    XCTAssertNotNil(date)
    
    //This test works fine in my timezone which is GMT+06:00
    //I think time in 2nd expression should be changed for your timezone
    XCTAssertEqual(date?.description, "2021-05-19 18:00:00 +0000")
  }
  
  func testTimeIntervalForOneHour() {
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = 2021
    components.month = 5
    components.day = 20
    components.hour = 21
    components.minute = 15
    let date = calendar.date(from: components)?.extractYearMonthDayFromDate()
    let hourInterval = WorkHour(7, for: date!).hourInterval

    //This test works fine in my timezone which is GMT+06:00
    //I think timestamps in 2nd expressions should be changed for your timezone
    XCTAssertEqual(hourInterval.start.timeIntervalSince1970, 1621472400)
    XCTAssertEqual(hourInterval.end.timeIntervalSince1970, 1621476000)
  }



}
