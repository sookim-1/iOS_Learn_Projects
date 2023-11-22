//
//  UserService.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/02.
//

import Firebase

class UserService: ObservableObject {
    
    static let shared = UserService()
    @Published var user: User?

    init() {
        fetchUser()
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            
            self.user = user
        }
    }
    
}
