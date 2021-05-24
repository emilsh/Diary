//
//  DataModel.swift
//  Diary
//
//  Created by Emil Shafigin on 18/5/21.
//

import Foundation
import RealmSwift

class DataModel {
  
  static let shared = DataModel()
  
  private let realm: Realm
  
  private init() {
    realm = try! Realm()
  }
  
  func fetchTasks(for date: Date) -> [Task] {
    var dailyTasks: [Task] = []
    let currentDayInTimeInterval = date.extractYearMonthDayFromDate()!.timeIntervalSince1970
    let tasks = realm.objects(Task.self).filter({ task in
      task.date_start >= currentDayInTimeInterval && task.date_start <= currentDayInTimeInterval + 86400
    })
    for task in tasks {
      dailyTasks.append(task)
    }
    return dailyTasks
  }
  
  func save(_ task: Task) {
    task.id = lastId() + 1
    try! realm.write {
      realm.add(task)
    }
  }
  
  func editTask(_ task: Task, with newTaskProps: Task) {
    try! realm.write {
      task.name = newTaskProps.name
      task.taskDescription = newTaskProps.taskDescription
      task.date_start = newTaskProps.date_start
      task.date_finish = newTaskProps.date_finish
    }
  }
  
  func removeTask(_ task: Task) {
    try! realm.write {
      realm.delete(task)
    }
  }
  
  func eraseAllData() {
    let tasks = realm.objects(Task.self)
    try! realm.write {
      realm.delete(tasks)
    }
  }
  
  func lastId() -> Int {
    guard let lastId = realm.objects(Task.self).last?.id else { return -1 }
    return lastId
  }
}
