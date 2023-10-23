//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by sookim on 10/23/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    static let reuseID = String(describing: TaskTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
