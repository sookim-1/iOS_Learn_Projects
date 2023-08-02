//
//  User.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/13.
//

import Foundation
import Firebase

enum AccountType: Int, Codable {
    case passenger
    case driver
}

struct User: Codable {
    let fullname: String
    let email: String
    let uid: String
    var coordinates: GeoPoint
    var accountType: AccountType        // 처음 모든 유저는 passenger로 등록 된후 var 변수로 driver로 변경
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
}
