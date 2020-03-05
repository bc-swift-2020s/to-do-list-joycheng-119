//
//  UIViewController+alert.swift
//  to do list
//
//  Created by cheng jiayi on 2020/3/5.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import UIKit

extension UIViewController{
    func oneButtonAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
