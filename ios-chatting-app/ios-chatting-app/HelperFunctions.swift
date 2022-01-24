//
//  HelperFunctions.swift
//  ios-chatting-app
//
//  Created by sookim on 2022/01/24.
//

import Foundation
import UIKit
import FirebaseFirestore

//MARK: GLOBAL FUNCTIONS
private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}
