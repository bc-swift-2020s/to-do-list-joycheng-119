//
//  ToDoItemss.swift
//  to do list
//
//  Created by cheng jiayi on 2020/3/4.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import Foundation
import UserNotifications

class ToDoItemss{
    var itemArray : [toDoItems] = []
 
    func saveData (){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
              let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
              let jsonEncoder = JSONEncoder()
              let data = try? jsonEncoder.encode(itemArray)
              do {
                  try data?.write(to: documentURL, options: .noFileProtection)
              }catch{
                  print("ERROR!\(error.localizedDescription)")
              }
        setNotifications()
    }
    func loadData(completed: @escaping () -> () ){
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")

            guard let data = try? Data(contentsOf: documentURL) else {
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                itemArray = try jsonDecoder.decode(Array<toDoItems>.self, from: data)
            }catch{
                print("ERROR!\(error.localizedDescription)")
            }
completed()
        }
    func setNotifications(){
        guard itemArray.count > 0 else{
            return
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        for i in 0...itemArray.count-1{
            if itemArray[i].reminderSet{
                let toDoItems = itemArray[i]
                itemArray[i].notificationID = localNotificationManager.setCalendarNotifications(title: toDoItems.name, subtitle: "", body: toDoItems.notes
                    , badgeNumber: nil, sound: .default, date: toDoItems.date)
            }
        }
    }
    }
