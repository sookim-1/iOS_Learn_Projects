//
//  HomeViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/02.
//

import MapKit
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine

class HomeViewModel: NSObject, ObservableObject {
    
    // MARK: - 프로퍼티
    
    @Published var drivers: [User] = []
    @Published var trip: Trip?
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    var currentUser: User?
    var routeToPickupLocation: MKRoute?
    
    // LocationSearchViewModel 프로퍼티
    @Published var results: [MKLocalSearchCompletion] = []          // 부분적인 문자열을 완성하는 완전한 형식의 문자열 (검색한 결과에 대한 title, subtitle을 담고있는 객체)
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()          // 검색하기 위해 사용할 객체
    var userLocation: CLLocationCoordinate2D?
    
    // 도착지 검색결과를 뷰모델에 저장하기 위해 사용
    var queryFragment: String = "" {
        didSet {
            print("도착지 검색 업데이트: \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        self.fetchUser()
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: - Helpers
    
    var tripCancelledMessage: String {
        guard let user = currentUser, let trip = trip else { return "" }
        
        if user.accountType == .passenger {
            if trip.state == .driverCancelled {
                return "기사가 여정을 취소했습니다."
            } else if trip.state == .passengerCancelled {
                return "여정을 취소했습니다."
            }
        } else {
            if trip.state == .driverCancelled {
                return "여정을 취소했습니다."
            } else if trip.state == .passengerCancelled {
                return "고객이 여정을 취소했습니다."
            }
        }
        
        return ""
    }
    
    func viewForState(_ state: MapViewState, user: User) -> some View {
        switch state {
        case .locationSelected, .polylineAdded:
            return AnyView(RideRequestView())
        case .tripRequested:
            if user.accountType == .passenger {
                return AnyView(TripLoadingView())
            } else {
                if let trip = self.trip {
                    return AnyView(AcceptTripView(trip: trip))
                }
            }
        case .tripAccepted:
            if user.accountType == .passenger {
                // 여기서는 환경변수로 trip 데이터 전달
                return AnyView(TripAcceptedView())
            } else {
                if let trip = self.trip {
                    // 아래에서는 의존성 주입
                    return AnyView(PickupPassengerView(trip: trip))
                }
            }
        case .tripCancelledByPassenger, .tripCancelledByDriver:
            return AnyView(TripCancelledView())
        default:
            break
        }
        
        return AnyView(Text(""))
    }

    // MARK: - User API
    
    /// 현재 사용자가 승객인 경우만 드라이버 정보 가져오는 메서드
    func fetchUser() {
        service.$user
            .sink { [weak self] user in
                guard let self else { return }
                self.currentUser = user
                
                guard let user else { return }
                
                if user.accountType == .passenger {
                    self.fetchDrivers()
                    self.addTripObserverForPassenger()
                } else {
                    self.addTripObserverForDriver()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateTripStatus(state: TripState) {
        guard let trip else { return }
        
        var data = ["state": state.rawValue]
        
        if state == .accepted {
            data["travelTimeToPassenger"] = trip.travelTimeToPassenger
        }
        
        Firestore.firestore().collection("trips").document(trip.id).updateData(data) { _ in
            print("DEBUG: 요청 상태 \(state) 업데이트")
        }
    }
    
    func deleteTrip() {
        guard let trip else { return }
        
        Firestore.firestore().collection("trips").document(trip.id).delete { _ in
            self.trip = nil
        }
    }
 
}

// MARK: - Passenger API
extension HomeViewModel {
    
    func addTripObserverForPassenger() {
        guard let currentUser = currentUser,
                currentUser.accountType == .passenger else { return }
        
        Firestore.firestore().collection("trips")
            .whereField("passengerUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                        change.type == .added || change.type == .modified else { return }
                
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                
                self.trip = trip
            }
    }
    
    /// 드라이버 정보만 가져오기
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let drivers = documents.compactMap({ try? $0.data(as: User.self) })
                
                self.drivers = drivers
            }
    }
    
    func requestTrip() {
        guard let driver = drivers.first else { return }
        guard let currentUser else { return }
        guard let dropoffLocation = selectedUberLocation else { return }

        
        let dropoffGeoPoint = GeoPoint(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)

        
        self.getPlacemark(forLocation: userLocation) { placemark, error in
            guard let placemark else { return }
            
            let tripCost = self.computeRiderPrice(forType: .uberX)
            
            let trip = Trip(passengerUid: currentUser.uid,
                            driverUid: driver.uid,
                            passengerName: currentUser.fullname,
                            driverName: driver.fullname,
                            passengerLocation: currentUser.coordinates,
                            driverLocation: driver.coordinates,
                            pickupLocationName: placemark.name ?? "현재 주소",
                            dropoffLocationName: dropoffLocation.title,
                            pickupLocationAddress: self.addressFromPlacemark(placemark),
                            pickupLocation: currentUser.coordinates,
                            dropoffLocation: dropoffGeoPoint,
                            tripCost: tripCost,
                            distanceToPassenger: 0.0,
                            travelTimeToPassenger: 0,
                            state: .requested)
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
            Firestore.firestore().collection("trips").document().setData(encodedTrip) { _ in
                print("여정 DB 저장 완료")
            }
        }
    }
    
    func cancelTripAsPassenger() {
        updateTripStatus(state: .passengerCancelled)
    }
    
}

// MARK: - Driver API
extension HomeViewModel {
    
    func addTripObserverForDriver() {
        guard let currentUser = currentUser,
                currentUser.accountType == .driver else { return }
        
        Firestore.firestore().collection("trips")
            .whereField("driverUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                        change.type == .added || change.type == .modified else { return }
                
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                
                self.trip = trip
                
                self.getDestinationRoute(from: trip.driverLocation.toCoordinate(), to: trip.pickupLocation.toCoordinate()) { route in
                    self.routeToPickupLocation = route
                    self.trip?.travelTimeToPassenger = Int(route.expectedTravelTime / 60)
                    self.trip?.distanceToPassenger = route.distance
                }
            }
    }
    
    /*
    func fetchTrips() {
        guard let currentUser else { return }
        
        Firestore.firestore().collection("trips")
            .whereField("driverUid", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents,
                      let document = documents.first else { return }
                
                guard let trip = try? document.data(as: Trip.self) else { return }

                self.trip = trip
                
                self.getDestinationRoute(from: trip.driverLocation.toCoordinate(), to: trip.pickupLocation.toCoordinate()) { route in
                    self.trip?.travelTimeToPassenger = Int(route.expectedTravelTime / 60)
                    self.trip?.distanceToPassenger = route.distance
                }
            }
    }
    */
    
    func rejectTrip() {
        updateTripStatus(state: .rejected)
    }
    
    func acceptTrip() {
        updateTripStatus(state: .accepted)
    }
    
    func cancelTripAsDriver() {
        updateTripStatus(state: .driverCancelled)
    }
    
}

// MARK: - LocationSearchHelpers
extension HomeViewModel {
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            result += " \(subThoroughfare)"
        }
        
        if let subadministrativeArea = placemark.subAdministrativeArea {
            result += ", \(subadministrativeArea)"
        }
        
        return result
    }
    
    // reverse geocoding
    func getPlacemark(forLocation location: CLLocation, completion: @escaping(CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error {
                completion(nil, error)
                
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        print("선택된 주소: \(localSearch.title)")
        
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error {
                print("에러 발생 : \(error.localizedDescription)")

                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            switch config {
            case .ride:
                self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
                print("선택된 위치 좌표: \(coordinate)")
            case .saveLocation(let viewModel):
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let savedLocation = SavedLocation(title: localSearch.title, address: localSearch.subtitle, coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                
                guard let encodedLocation = try? Firestore.Encoder().encode(savedLocation) else { return }
                Firestore.firestore().collection("users").document(uid).updateData([
                    viewModel.databaseKey: encodedLocation
                ])
                print("선택된 위치 좌표: \(coordinate)")
            }
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
extension HomeViewModel: MKLocalSearchCompleterDelegate {
    
    // 검색배열을 업데이트할 때 호출
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
    
}
