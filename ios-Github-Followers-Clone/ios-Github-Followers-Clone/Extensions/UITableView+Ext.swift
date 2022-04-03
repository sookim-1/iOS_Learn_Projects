//
//  UITableView+Ext.swift
//  ios-Github-Followers-Clone
//
//  Created by sookim on 2022/04/03.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
}
