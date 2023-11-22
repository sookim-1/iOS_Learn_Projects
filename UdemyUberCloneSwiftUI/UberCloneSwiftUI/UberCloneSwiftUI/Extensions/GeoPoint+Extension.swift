//
//  GeoPoint+Extension.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/06.
//

import Foundation
import Firebase
import CoreLocation

extension GeoPoint {
    
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
