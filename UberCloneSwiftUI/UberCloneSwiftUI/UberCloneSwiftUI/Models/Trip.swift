//
//  Trip.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/06.
//

import Foundation
import Firebase

struct Trip: Identifiable, Codable {
    
    let id: String
    let passengerUid: String
    let driverUid: String
    let passengerName: String
    let driverName: String
    let passengerLocation: GeoPoint
    let driverLocation: GeoPoint
    let pickupLocationName: String
    let dropoffLocationName: String
    let pickupLocationAddress: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let tripCost: Double
    var distanceToPassenger: Double
    var travelTimeToPassenger: Int
}
