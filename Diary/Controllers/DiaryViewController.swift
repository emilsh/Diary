//
//  DiaryViewController.swift
//  Diary
//
//  Created by Emil Shafigin on 18/5/21.
//

import UIKit

class DiaryViewController: UIViewController {
  
  let cellId = "TaskCell"
  var workingHours: WorkingHours?
  var dailyTasks: [Task] = []
  let dataModel = DataModel.shared
    
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    navigationController?.navigationBar.titleTextAttributes =
      [.foregroundColor: UIColor(red: 211/255, green: 253/255, blue: 253/255, alpha: 1),
       .font: UIFont(name: "MarkerFelt-Wide", size: 20)!]
    
    prepareListData()
  }
  
  //MARK: - Actions
  @IBAction func dateChanged(_ sender: Any) {
    prepareListData()
    tableView.reloadData()
  }
  
  //MARK: - Helper methods
  fileprivate func prepareListData() {
    fetchDailyTasks()
    workingHours = WorkingHours(for: datePicker.date.extractYearMonthDayFromDate()!)
  }
  
  private func fetchDailyTasks() {
    dailyTasks.removeAll()
    dailyTasks = dataModel.fetchTasks(for: datePicker.date)
  }
  
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowTask" {
      let controller = segue.destination as! TaskDetailsViewController
      controller.delegate = self
      
      if let indexPath = tableView.indexPath(for: sender as! TaskCell) {
        let task = dailyTasks.first { tsk in
          tsk === workingHours?.hours[indexPath.row].task
        }
        if task != nil {
          controller.taskToEdit = task
        } else {
          controller.currentDate = workingHours?.hours[indexPath.row]
        }
      }
    } else if segue.identifier == "AddTask" {
      let controller = segue.destination as! TaskDetailsViewController
      controller.delegate = self
      controller.date = datePicker.date
    }
  }
}

extension DiaryViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let workingHours =  workingHours?.hours else {
      return 0
    }
    return workingHours.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskCell
    cell.blockView.removeFromSuperview()
        
    guard let workingHour = workingHours?.hours[indexPath.row] else { return cell } //throw an error
    
    for task in dailyTasks {
      let taskDateInterval = DateInterval(start: task.date_start + 1, finish: task.date_finish - 1)
      if workingHour.hourInterval.intersects(taskDateInterval) {
        let intersection = workingHour.hourInterval.intersection(with: taskDateInterval)
        let rect = cell.rectForBlockView(with: intersection!)
        
        let previousTask = indexPath.row != 0 ? workingHours?.hours[indexPath.row - 1].task : nil
        cell.configureCell(with: rect, for: task, with: previousTask)
        workingHour.task = task
      }
    }    
    cell.addWorkingHours(workingHour.hourInString)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    if let task = workingHours?.hours[indexPath.row].task {
//      guard let index = dailyTasks.firstIndex(of: task) else { return }
//      dailyTasks.remove(at: index)
//      dataModel.removeTask(task)
//      workingHours?.hours[indexPath.row].task = nil
//
//      //I did this for leaving deletion animation
//      let workHour = workingHours?.hours.remove(at: indexPath.row)
//      tableView.deleteRows(at: [indexPath], with: .fade)
//      workingHours?.hours.insert(workHour!, at: indexPath.row)
//      tableView.insertRows(at: [indexPath], with: .none)
//    }
//  }
  
//  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//    if workingHours?.hours[indexPath.row].task != nil {
//      return true
//    } else {
//      return false
//    }
//  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

extension DiaryViewController: TaskDetailsViewControllerDelegate {
  
  func taskDetailsViewController(controller: TaskDetailsViewController, didFinishAdding task: Task) {
    dataModel.save(task)
    fetchDailyTasks()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func taskDetailsViewController(controller: TaskDetailsViewController, didFinishEditing task: Task, with newTaskProps: Task) {
    dataModel.editTask(task, with: newTaskProps)
    fetchDailyTasks()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func taskDetailsViewController(controller: TaskDetailsViewController, didFinishRemoving task: Task) {
    guard let index = dailyTasks.firstIndex(of: task) else { return }
    dailyTasks.remove(at: index)
    dataModel.removeTask(task)
    
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func taskDetailsViewControllerDidCancel(controller: TaskDetailsViewController) {
    navigationController?.popViewController(animated: true)
  }
}
