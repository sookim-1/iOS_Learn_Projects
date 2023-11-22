//
//  Task.swift
//  ToDoList
//
//  Created by sookim on 10/23/23.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
