//
//  Date+Ext.swift
//  ios-Github-Followers-Clone
//
//  Created by sookim on 2022/03/07.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
