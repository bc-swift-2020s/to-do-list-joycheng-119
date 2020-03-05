//
//  TableViewCell.swift
//  to do list
//
//  Created by cheng jiayi on 2020/3/1.
//  Copyright © 2020 cheng jiayi. All rights reserved.
//

import UIKit
protocol ListTableViewCellDelegate: class {
    func checkBoxToggle(sender: ListTableViewCellDelegate)
}
class TableViewCell: UITableViewCell {
    
    weak var delegate: ListTableViewCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    var toDoItem: toDoItems!{
            didSet{
                nameLabel.text = toDoItem.name
                checkBoxButton.isSelected = toDoItem.completed
            }
        }
                
        @IBAction func checkToggled(_ sender: UIButton) {
            delegate?.checkBoxToggle(sender: self)
        }
         
        
    }

