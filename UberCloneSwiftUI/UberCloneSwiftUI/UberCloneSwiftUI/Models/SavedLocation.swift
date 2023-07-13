//
//  SavedLocation.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/14.
//

import Foundation
import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint   // firebase 위경도 저장하는 자료형
}
