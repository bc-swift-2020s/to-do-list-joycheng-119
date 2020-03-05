//
//  ToDoItems.swift
//  to do list
//
//  Created by cheng jiayi on 2020/2/8.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import Foundation


struct toDoItems: Codable {
      var date: Date
      var name: String
      var notes: String
      var reminderSet: Bool
    var notificationID: String?
    var completed: Bool
  }
