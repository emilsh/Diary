//
//  TaskCell.swift
//  Diary
//
//  Created by Emil Shafigin on 18/5/21.
//

import UIKit

class TaskCell: UITableViewCell {
  
  var blockView: UIView = UIView()
  var timeCellLabel: UILabel = UILabel()
  var nameCellLabel: UILabel = UILabel()
  
  func configureCell(with rect: CGRect, for task: Task, with previousTask: Task?) {
    let rectForBlockView = CGRect(x: 0, y: rect.minY, width: rect.width, height: rect.height)
    blockView = UIView(frame: rectForBlockView)
    blockView.backgroundColor = UIColor(red: 85/255, green: 175/255, blue: 208/255, alpha: 1)
    
    blockView.alpha = 0.85
    
    if task === previousTask {
      //do nothing
    } else {
      let rectForNameCellLabel = CGRect(x: 16, y: 0, width: rect.width - 50, height: rect.height)
      nameCellLabel = UILabel(frame: rectForNameCellLabel)
      nameCellLabel.font = UIFont(name: "MarkerFelt-Thin", size: 15)
      nameCellLabel.textColor = UIColor(red: 211/255, green: 253/255, blue: 253/255, alpha: 1)
      
      let taskTime = "\(task.date_start.timeFromTimeInterval()) - \(task.date_finish.timeFromTimeInterval())"
        
      nameCellLabel.text = "\(task.name) - \(taskTime)"
      blockView.addSubview(nameCellLabel)
    }
    self.addSubview(blockView)
  }
  
  func rectForBlockView(with intersection: DateInterval) -> CGRect {
    let startDate = intersection.start
    let endDate = intersection.end

    let calendar = Calendar.current
    let componentsForStartDate = calendar.dateComponents([.hour, .minute], from: startDate)
    let componentsForEndDate = calendar.dateComponents([.hour, .minute], from: endDate)
    
    let yStarts = self.frame.height / 60 * CGFloat(componentsForStartDate.minute!)
    let minutesForEnd = componentsForEndDate.minute == 0 ? 60 : componentsForEndDate.minute
    let yEnds: CGFloat = self.frame.height / 60.0 * CGFloat(minutesForEnd!)
    let height = yEnds - yStarts
    let rect = CGRect(x: self.frame.minX, y: yStarts, width: self.frame.width, height: height)
    
    return rect
  }
  
  func addWorkingHours(_ hours: String) {
    timeCellLabel.removeFromSuperview()
    let rect = CGRect(x: self.frame.maxX - 108, y: 0, width: 100, height: 40)
    timeCellLabel = UILabel(frame: rect)
    timeCellLabel.textAlignment = .right
    timeCellLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
    timeCellLabel.text = hours
    self.addSubview(timeCellLabel)
  }
  
}
