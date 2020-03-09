//
//  ToDoDetailTableViewController.swift
//  to do list
//
//  Created by cheng jiayi on 2020/2/6.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import UIKit
import UserNotifications

private let dateFormatter: DateFormatter = {
    print("i just created a dateformatter!")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
    
}()


class ToDoDetailTableViewController: UITableViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    
    var toDoList: toDoItems!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeight : CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        nameField.delegate = self
        if toDoList == nil{
            toDoList = toDoItems(date: Date().addingTimeInterval(24*60*60), name: "", notes: "", reminderSet: false, completed: false)
            nameField.becomeFirstResponder()
        }
//        nameField.text = toDoList.name
//        datePicker.date = toDoList.date
//        noteView.text = toDoList.notes
//        reminderSwitch.isOn = toDoList.reminderSet
//        dateLabel.textColor = (reminderSwitch.isOn ? .black :.gray)
//        if reminderSwitch.isOn {
//            dateLabel.textColor = .black
//        } else{
//            dateLabel.textColor = .gray
//        }
        updateUserInterface()
    }
    @objc func appActiveNotification () {
     print("This app just came to the foreground!")
        updateReminderSwitch()
    }
    func updateUserInterface(){
        nameField.text = toDoList.name
        datePicker.date = toDoList.date
        noteView.text = toDoList.notes
        reminderSwitch.isOn = toDoList.reminderSet
        dateLabel.textColor = (reminderSwitch.isOn ? .black :.gray)
        dateLabel.text = dateFormatter.string(from: toDoList.date)
        enableDisabledButton(text: nameField.text!)
        updateReminderSwitch()
    }
    
    
    
    func updateReminderSwitch(){
        localNotificationManager.isAuthorized { (authorized) in
            DispatchQueue.main.async {
                if !authorized && self.reminderSwitch.isOn{
                    self.oneButtonAlert(title: "User has not allowed notification", message: "To receive alerts for reminders, open the Setting APP, select To Do List > Notification > Allow Notification.")
                    self.reminderSwitch.isOn = false
                           }
                self.view.endEditing(true)
                self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black : .gray)
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
           
        }
    }
    
//    func updateReminderSwitch(){
//        localNotificationManager.isAuthorized(completed: { (authorized) in
//            DispatchQueue.main.async {
//                if !authorized && self.reminderSwitch.isOn{
//                    self.oneButtonAlert(title: "User has not yet allowed notification", message: "if you want to receive alerts, please go to settings")
//                    self.reminderSwitch.isOn = false
//
//                }
//                self.view.endEditing(true)
//                self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black :.gray)
//                self.tableView.beginUpdates()
//                self.tableView.endUpdates()
//            }
//
//        }
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoList = toDoItems(date: datePicker.date, name: nameField.text!, notes: noteView.text, reminderSet: reminderSwitch.isOn,  completed: toDoList.completed)
    }
    func enableDisabledButton(text: String){
        if text.count > 0{
                   saveBarButton.isEnabled = true
               }else{
                   saveBarButton.isEnabled = false
               }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        updateReminderSwitch()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        enableDisabledButton(text: sender.text!)
    }
}

extension ToDoDetailTableViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
        case datePickerIndexPath:
            return reminderSwitch.isOn ? datePicker.frame.height : 0
        case notesTextViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
        }
    }
}
    

extension ToDoDetailTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteView.becomeFirstResponder()
        return true
    }
    
}
