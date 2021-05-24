//
//  TaskDetailsViewController.swift
//  Diary
//
//  Created by Emil Shafigin on 20/5/21.
//

import UIKit

protocol TaskDetailsViewControllerDelegate: AnyObject {
  func taskDetailsViewControllerDidCancel(controller: TaskDetailsViewController)
  func taskDetailsViewController(controller: TaskDetailsViewController, didFinishAdding task: Task)
  func taskDetailsViewController(controller: TaskDetailsViewController, didFinishEditing task: Task, with newTaskProps: Task)
  func taskDetailsViewController(controller: TaskDetailsViewController, didFinishRemoving task: Task)
}

class TaskDetailsViewController: UITableViewController {
  
  var taskToEdit: Task?
  var currentDate: WorkHour?
  var date: Date?
  weak var delegate: TaskDetailsViewControllerDelegate?
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var startDatePicker: UIDatePicker!
  @IBOutlet weak var endDatePicker: UIDatePicker!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nameTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    saveButton.isEnabled = false
    nameTextField.becomeFirstResponder()
    saveButton.title = taskToEdit != nil ? "Сохранить" : "Добавить"
    updateUI()
    prepareNavBar()
  }
  
  //MARK: - Actions
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    if taskToEdit != nil {
      //Edit current task
      let newTask = Task()
      newTask.name = nameTextField.text!
      newTask.taskDescription = descriptionTextView.text
      newTask.date_start = startDatePicker.date.timeIntervalSince1970
      newTask.date_finish = endDatePicker.date.timeIntervalSince1970
      
      if newTask.date_start < newTask.date_finish {
        delegate?.taskDetailsViewController(controller: self, didFinishEditing: taskToEdit!, with: newTask)
      } else {
        //Call alert
        alertForDates()
      }
    } else {
      //Create new task
      let date_start = startDatePicker.date.timeIntervalSince1970
      let date_finish = endDatePicker.date.timeIntervalSince1970

      if date_start < date_finish {
        let task = Task()
        task.name = nameTextField.text!
        task.date_start = date_start
        task.date_finish = date_finish
        task.taskDescription = descriptionTextView.text
        
        saveButton.title = "Добавить"
        delegate?.taskDetailsViewController(controller: self, didFinishAdding: task)
      } else {
        alertForDates()
      }
    }
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any) {
    delegate?.taskDetailsViewControllerDidCancel(controller: self)
  }
  
  
  @IBAction func removeButtonTapped(_ sender: Any) {
    if let task = taskToEdit {
      delegate?.taskDetailsViewController(controller: self, didFinishRemoving: task)
    }
  }
  
  //MARK: - Helper methods
  fileprivate func updateUI() {
    if let task = taskToEdit {
      nameTextField.text = task.name
      descriptionTextView.text = task.taskDescription
      startDatePicker.date = Date(timeIntervalSince1970: task.date_start)
      endDatePicker.date = Date(timeIntervalSince1970: task.date_finish)
      removeButton.isEnabled = true
      saveButton.isEnabled = true
    } else if currentDate != nil {
      startDatePicker.date = currentDate!.hourInterval.start
      endDatePicker.date = currentDate!.hourInterval.end
      removeButton.isEnabled = false
      removeButton.alpha = 0.3
    } else {
      guard let date = date else { return }
      startDatePicker.date = date
      endDatePicker.date = date.addingTimeInterval(3600)
      
      removeButton.isEnabled = false
      removeButton.alpha = 0.3
    }
  }
  
  fileprivate func prepareNavBar() {
    let navButtonsTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(red: 211/255, green: 253/255, blue: 253/255, alpha: 1), .font: UIFont(name: "MarkerFelt-Wide", size: 20)!]
    
    navigationController?.navigationBar.titleTextAttributes = navButtonsTextAttributes
    
    saveButton.setTitleTextAttributes(navButtonsTextAttributes, for: .normal)
    saveButton.setTitleTextAttributes(navButtonsTextAttributes, for: .selected)
    saveButton.setTitleTextAttributes([.foregroundColor: UIColor(red: 211/255, green: 253/255, blue: 253/255, alpha: 0.5), .font: UIFont(name: "MarkerFelt-Wide", size: 20)!], for: .disabled)
    
    cancelButton.setTitleTextAttributes(navButtonsTextAttributes, for: .normal)
//    cancelButton.setTitleTextAttributes(navButtonsTextAttributes, for: .normal)
    
  }
  
  fileprivate func alertForDates() {
    let title = "Дата и время задачи"
    let message = "Дата завершения задачи не может быть раньше даты начала. Пожалуйста, проверьте дату и время завершения задачи."
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(alertAction)
    present(alert, animated: true, completion: nil)
  }
}

extension TaskDetailsViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let oldText: NSString = textField.text! as NSString
      let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
      saveButton.isEnabled = (newText.length > 0)
      return true
  }
}
