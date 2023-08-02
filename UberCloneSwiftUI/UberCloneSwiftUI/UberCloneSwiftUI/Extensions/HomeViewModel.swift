//
//  HomeViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/02.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var drivers: [User] = []
    var currentUser: User?
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchUser()
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
    
    /// 현재 사용자가 승객인 경우만 드라이버 정보 가져오는 메서드
    func fetchUser() {
        service.$user
            .sink { [weak self] user in
                guard let self
                else { return }
                
                guard let user
                else { return }
                
                self.currentUser = user
                guard user.accountType == .passenger else { return }
                self.fetchDrivers()
            }
            .store(in: &cancellables)
    }
    
}
