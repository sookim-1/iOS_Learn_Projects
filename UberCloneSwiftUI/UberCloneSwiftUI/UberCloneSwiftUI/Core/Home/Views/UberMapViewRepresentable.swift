//
//  UberMapViewRepresentable.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import MapKit
import SwiftUI

// SwiftUI에도 맵뷰가 있지만 많은 기능을 지원하지 않아서 MKMapView사용
// UIViewRepresentable: UIKit 뷰를 SwiftUI 뷰 계층에 통합하는데 사용하는 프로토콜
struct UberMapViewRepresentable: UIViewRepresentable {
    
    // 해당 괄호의 메서드들은 모두 UIViewRepresentable의 메서드이고 MKMapViewDelegate는 Coordinator를 통해서 처리합니다.
    
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    // 뷰를 생성
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    // 뷰를 실제로 업데이트
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let selectedLocation = locationViewModel.selectedLocation {
            print("지도 화면에서 선택된 위치 : \(selectedLocation) ")
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}

// MARK: - MapCoordinator 서브클래스
extension UberMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        let parent: UberMapViewRepresentable
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            
            super.init()
        }
        
        // 지도 업데이트
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // center: 위경도 좌표, span: 확대축소
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            parent.mapView.setRegion(region, animated: true)
        }

    }
    
}
