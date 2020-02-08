//
//  ToDoDetailTableViewController.swift
//  to do list
//
//  Created by cheng jiayi on 2020/2/6.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    
    var toDoList: toDoItems!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if toDoList == nil{
            toDoList = toDoItems(date: Date(), name: "", notes: "")
        }
        nameField.text = toDoList.name
        datePicker.date = toDoList.date
        noteView.text = toDoList.notes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoList = toDoItems(date: datePicker.date, name: nameField.text!, notes: noteView.text)
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    }
    

