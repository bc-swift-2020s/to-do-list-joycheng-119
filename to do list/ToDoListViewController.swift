//
//  ViewController.swift
//  to do list
//
//  Created by cheng jiayi on 2020/2/6.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import UIKit
import UserNotifications



class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
//var toDoItem : [toDoItems] =  []
    var toDoItems = ToDoItemss()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        toDoItems.loadData {
            self.tableView.reloadData()
        }
       
        localNotificationManager.authorizeLocalNotifications(completed: self)
    }
    
    
    func saveData (){
        toDoItems.saveData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableView .indexPathForSelectedRow!
            destination.toDoList = toDoItems.itemArray[selectedIndexPath.row]
        }else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue){
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow{
            toDoItems.itemArray[selectedIndexPath.row] = source.toDoList
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }else {
            let newIndexPath = IndexPath(row: toDoItems.itemArray.count, section: 0)
            toDoItems.itemArray.append(source.toDoList)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom
                , animated: true)
            
        }
        saveData()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
            
        }else{
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
}

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate, ListTabelViewCellDelegate {
    
    func checkBoxToggle(sender: ListTabelViewCellDelegate) {
        if let selectedIndexPath = tableView.indexPath(for: sender as! UITableViewCell){
            toDoItems.itemArray[selectedIndexPath.row].completed = !toDoItems.itemArray[selectedIndexPath.row].completed
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic )
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("number of rows in section was just called. returning\(toDoItems.itemArray.count)")
        return toDoItems.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt was just called for indexPath row = \(indexPath.row) which is cell containing \(toDoItems.itemArray[indexPath.row])")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.delegate = self as! ListTableViewCellDelegate
        cell.toDoItem = toDoItems.itemArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            toDoItems.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItems.itemArray[sourceIndexPath.row]
        toDoItems.itemArray.remove(at: sourceIndexPath.row)
        toDoItems.itemArray.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
}



