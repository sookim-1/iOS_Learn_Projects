//
//  UberLocation.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/03.
//

import CoreLocation

struct UberLocation: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
    
}
