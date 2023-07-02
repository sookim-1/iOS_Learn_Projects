//
//  LocationManager.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()                   // EnvironMentObject로도 구현할 수 있음
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest           // 가장 정확한 위치옵션
        locationManager.requestWhenInUseAuthorization()                     // 위치 권한 요청
        locationManager.startUpdatingLocation()                             // 사용자 위치 업데이트
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    // 위치업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
    
        self.userLocation = location.coordinate
        print("위치 업데이트 시작: \(String(describing: locations.first))")
        locationManager.stopUpdatingLocation()                              // 해당 메서드를 한번만 호출하기 위해서 중지처리
    }
    
}
