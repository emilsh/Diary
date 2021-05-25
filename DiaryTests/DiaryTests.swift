//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by Emil Shafigin on 21/5/21.
//

import XCTest
@testable import Diary

class DiaryTests: XCTestCase {
  
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
  
  func testRectForBlockView() {
    let dateInterval = DateInterval(start: Date(timeIntervalSince1970: 0), duration: 900)
    
    let cell = TaskCell()
    let rect = cell.rectForBlockView(with: dateInterval)
    let height = cell.frame.height / 60 * 900 / 60
    let resultRect = CGRect(x: 0, y: 0, width: cell.frame.width, height: height)
    
    XCTAssertEqual(rect, resultRect)
  }
  
  func testWorkHour() {
    let date = Date(timeIntervalSince1970: 0)
    let workHour = WorkHour(1, for: date)
    let timeInterval = DateInterval(start: 3600, finish: 7200)
    
    XCTAssertEqual(workHour.hourInString, "1.00 - 2.00")
    XCTAssertEqual(workHour.hourInterval, timeInterval)
  }
  
  func testWorkingHours() {
    let date = Date(timeIntervalSince1970: 0)
    let workingHours = WorkingHours(for: date)
    
    XCTAssertEqual(workingHours.hours.count, 15)
    XCTAssertEqual(workingHours.hours[0].hourInString, "7.00 - 8.00")
  }
    
  

}
