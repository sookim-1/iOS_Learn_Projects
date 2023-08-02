//
//  DriverAnnotation.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/02.
//

import Foundation
import MapKit
import Firebase

class DriverAnnotation: NSObject, MKAnnotation {
    
    let uid: String
    var coordinate: CLLocationCoordinate2D
    
    init(driver: User) {
        self.uid = driver.uid
        self.coordinate = CLLocationCoordinate2D(latitude: driver.coordinates.latitude,
                                                 longitude: driver.coordinates.longitude)
    }
    
}
