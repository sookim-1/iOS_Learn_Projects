//
//  HomeViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/02.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    
    @Published var drivers: [User] = []
    
    init() {
        fetchDrivers()
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
    
}
