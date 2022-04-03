//
//  UIView+Ext.swift
//  ios-Github-Followers-Clone
//
//  Created by sookim on 2022/04/02.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
