//
//  ViewController.swift
//  to do list
//
//  Created by cheng jiayi on 2020/2/6.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import UIKit



class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
     var toDoItem : [toDoItems] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    func loadData () {
               let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
               let documentURL = directoryURL.appendingPathComponent("todos").appendingPathComponent("json")
               
               guard let data = try? Data(contentsOf: documentURL)else{
                   return
               }
               let jsonDecoder = JSONDecoder()
               do {
                   toDoItem = try jsonDecoder.decode(Array<toDoItems>.self, from: data)
                   tableView.reloadData()
               }catch{
                   print("ERROR!\(error.localizedDescription)")
               }
               
           }
    
    
    func saveData (){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathComponent("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(toDoItem)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        }catch{
            print("ERROR!\(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableView .indexPathForSelectedRow!
            destination.toDoList = toDoItem[selectedIndexPath.row]
        }else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue){
    let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow{
            toDoItem[selectedIndexPath.row] = source.toDoList
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }else {
            let newIndexPath = IndexPath(row: toDoItem.count, section: 0)
            toDoItem.append(source.toDoList)
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

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("number of rows in section was just called. returning\(toDoItem.count)")
        return toDoItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt was just called for indexPath row = \(indexPath.row) which is cell containing \(toDoItem[indexPath.row])")
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = toDoItem[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            toDoItem.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItem[sourceIndexPath.row]
        toDoItem.remove(at: sourceIndexPath.row)
        toDoItem.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    }



