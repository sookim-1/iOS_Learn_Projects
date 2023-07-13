//
//  LocationSearchViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import Foundation
import MapKit

enum LocationResultsViewConfig {
    case ride
    case saveLocation
}

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - 프로퍼티
    @Published var results: [MKLocalSearchCompletion] = []          // 부분적인 문자열을 완성하는 완전한 형식의 문자열 (검색한 결과에 대한 title, subtitle을 담고있는 객체)
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()          // 검색하기 위해 사용할 객체
    
    // 도착지 검색결과를 뷰모델에 저장하기 위해 사용
    var queryFragment: String = "" {
        didSet {
            print("도착지 검색 업데이트: \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    // MARK: Lifecycle
    override init() {
        super.init()
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: - Helpers
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        print("선택된 주소: \(localSearch.title)")
        
        switch config {
        case .ride:
            locationSearch(forLocalSearchCompletion: localSearch) { response, error in
                if let error {
                    print("에러 발생 : \(error.localizedDescription)")

                    return
                }
                
                guard let item = response?.mapItems.first else { return }
                let coordinate = item.placemark.coordinate
                
                self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
                print("선택된 위치 좌표: \(coordinate)")
            }
        case .saveLocation:
            print("DEBUG: 저장된 주소")
        }
    }
    
    // 주소 문자열을 이용하여 위경도 좌표 구하는 메서드
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping (MKLocalSearch.CompletionHandler)) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRiderPrice(forType type: RideType) -> Double {
        guard let destCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
        
        let tripDistanceInMeters = userLocation.distance(from: destination)
        
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    // 경로가져오는 메서드
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error {
                print("경로 계산 오류: \(error.localizedDescription)")
                
                return
            }

            guard let route = response?.routes.first else { return }
            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    // 예상이동시간 구하는 메서드
    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
    
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    
    // 검색배열을 업데이트할 때 호출
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
    
}
