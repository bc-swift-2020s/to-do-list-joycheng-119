//
//  LocalNotificationManager.swift
//  to do list
//
//  Created by cheng jiayi on 2020/3/4.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

struct localNotificationManager {
    
    static func authorizeLocalNotifications(completed: @escaping (Bool) -> () ) {
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
               guard error == nil else{
                   print("error: \(error!.localizedDescription)")
                completed(false)
                   return
               }
               if granted{
                   print("notification authorization granted!")
               }else{
                   print("the user has denied notifications")
            }
           }
       }
    
    
    static func isAuthorized(viewController: UIViewController) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else{
                print("error: \(error!.localizedDescription)")
                return
            }
            if granted{
                print("notification authorization granted!")
            }else{
                print("the user has denied notifications")
             DispatchQueue.main .async {
             viewController.oneButtonAlert(title: "User has not yet allowed notification", message: "if you want to receive alerts, please go to settings")
             }
         }
        }
    }
   static func setCalendarNotifications(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String{
           //create content:
           let content = UNMutableNotificationContent()
           content.title = title
           content.subtitle = subtitle
           content.body = body
           content.sound = sound
           content.badge = badgeNumber
           
           //create trigger
           var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
           dateComponents.second = 00
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
           
           //create request
           let notificationID = UUID().uuidString
           let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
            
           //register request with the notification center
           UNUserNotificationCenter.current().add(request) { (error) in
               if let error = error{
                   print("Error: \(error.localizedDescription), adding notifications went wrong!")
               }else{
                   print("notification scheduled \(notificationID), title: \(content.title)")
               }
           }
           return notificationID
       }
}
