//
//  LocationSearchViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - 프로퍼티
    @Published var results: [MKLocalSearchCompletion] = []          // 부분적인 문자열을 완성하는 완전한 형식의 문자열 (검색한 결과에 대한 title, subtitle을 담고있는 객체)
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    
    private let searchCompleter = MKLocalSearchCompleter()          // 검색하기 위해 사용할 객체
    
    // 도착지 검색결과를 뷰모델에 저장하기 위해 사용
    var queryFragment: String = "" {
        didSet {
            print("도착지 검색 업데이트: \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: Lifecycle
    override init() {
        super.init()
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: - Helpers
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        print("선택된 주소: \(localSearch.title)")
        
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error {
                print("에러 발생 : \(error.localizedDescription)")

                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            self.selectedLocationCoordinate = coordinate
            print("선택된 위치 좌표: \(coordinate)")
        }
    }
    
    // 주소 문자열을 이용하여 위경도 좌표 구하는 메서드
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping (MKLocalSearch.CompletionHandler)) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    
    // 검색배열을 업데이트할 때 호출
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
    
}
