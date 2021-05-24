//
//  Task.swift
//  Diary
//
//  Created by Emil Shafigin on 18/5/21.
//

import Foundation
import RealmSwift

class Task: Object {
  @objc dynamic var id: Int = -1
  @objc dynamic var date_start: TimeInterval = 0
  @objc dynamic var date_finish: TimeInterval = 0
  @objc dynamic var name: String = ""
  @objc dynamic var taskDescription: String = ""
}
