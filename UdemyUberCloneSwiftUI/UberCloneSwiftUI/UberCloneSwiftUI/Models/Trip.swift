//
//  Trip.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/06.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum TripState: Int, Codable {
    case requested
    case rejected
    case accepted
    case passengerCancelled
    case driverCancelled
}

struct Trip: Identifiable, Codable {
    
    @DocumentID var tripId: String?               // firebasefirestorSwift에서 제공하는 기능 DB 문서 ID값을 가져옵니다.
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
    var state: TripState
    
    var id: String {
        return tripId ?? ""
    }
}
