//
//  DeveloperPreview.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/02.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    
    // extension에서는 프로퍼티를 저장할 수 없기 때문에 정적변수로 설정
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockUser = User(fullname: "Test",
                        email: "Test@gmail.com",
                        uid: NSUUID().uuidString,
                        coordinates: GeoPoint(latitude: 37.577949, longitude: 126.973046),
                        accountType: .passenger,
                        homeLocation: nil,
                        workLocation: nil)
    
    let mockTrip = Trip(id: NSUUID().uuidString,
                        passengerUid: NSUUID().uuidString,
                        driverUid: NSUUID().uuidString,
                        passengerName: "Test",
                        driverName: "Driver Test",
                        passengerLocation: .init(latitude: 37.579949, longitude: 126.973046),
                        driverLocation: .init(latitude: 37.577949, longitude: 126.973046),
                        pickupLocationName: "현재 주소",
                        dropoffLocationName: "도착지 주소",
                        pickupLocationAddress: "테스트 주소",
                        pickupLocation: .init(latitude: 37.579949, longitude: 126.973046),
                        dropoffLocation: .init(latitude: 37.577949, longitude: 126.973046),
                        tripCost: 50.0,
                        distanceToPassenger: 1000,
                        travelTimeToPassenger: 24
    )
}

