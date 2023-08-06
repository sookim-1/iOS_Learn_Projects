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
    @Binding var mapState: MapViewState
    // @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
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
        print("MapState 변경 : \(mapState)")
        
        // FIXME: break 호출해야 하는 이유, 이전에 경로가 제거되지 않던 이유 ->
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            context.coordinator.addDriversToMap(homeViewModel.drivers)
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedUberLocation?.coordinate {
                print("🚨 (updateUIView 계속해서 호출) 지도 화면에서 선택된 위치 : \(coordinate) ")
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}

// MARK: - MapCoordinator 서브클래스
extension UberMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        // MARK: - 프로퍼티
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        // MARK: - Lifecycle
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        // 지도 업데이트될 때 호출되는 메서드
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            
            // center: 위경도 좌표, span: 확대축소
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        
        // 지도에 오버레이를 그리도록 지시하는 경우 사용하는 메서드
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                
                view.image = UIImage(systemName: "screwdriver.fill")
                
                return view
            }
            
            return nil
        }

        // MARK: - Helpers
        
        // 맵뷰 annotation추가하는 메서드
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)             // 마커 모두 제거
            
            let destinationAnno = MKPointAnnotation()
            destinationAnno.coordinate = coordinate
            parent.mapView.addAnnotation(destinationAnno)
            parent.mapView.selectAnnotation(destinationAnno, animated: true)
        }
        
        // 지도에 경로 그리는 메서드
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate else { return }
            
            parent.homeViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { [weak self] route in
                guard let self else { return }
                
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                // 현재위치와 도착지 마커를 지도 반경에 맞도록 설정
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        func addDriversToMap(_ drivers: [User]) {
            let annotations = drivers.map({ DriverAnnotation(driver: $0) })
            
            self.parent.mapView.addAnnotations(annotations)
        }
    }
    
}
