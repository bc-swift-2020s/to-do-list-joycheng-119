//
//  ToDoDetailTableViewController.swift
//  to do list
//
//  Created by cheng jiayi on 2020/2/6.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import UIKit

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
        if toDoList == nil{
            toDoList = toDoItems(date: Date().addingTimeInterval(24*60*60), name: "", notes: "", reminderSet: false)
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
    func updateUserInterface(){
        nameField.text = toDoList.name
        datePicker.date = toDoList.date
        noteView.text = toDoList.notes
        reminderSwitch.isOn = toDoList.reminderSet
        dateLabel.textColor = (reminderSwitch.isOn ? .black :.gray)
        dateLabel.text = dateFormatter.string(from: toDoList.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoList = toDoItems(date: datePicker.date, name: nameField.text!, notes: noteView.text, reminderSet: reminderSwitch.isOn)
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
         dateLabel.textColor = (reminderSwitch.isOn ? .black :.gray)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: sender.date)
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
    

