//
//  AuthViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/12.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    
    // Firebase 인증 세션 : 로그인 한 사용자에 대한 정보들 저장하고 해당 값으로 로그인 여부 판별
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("DEBUG: 로그인 에러발생: \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: 로그인 성공")
            
            if let result {
                print("DEBUG: User id\(result.user.uid))")
                self.userSession = result.user
                self.fetchUser()
            }
        }
    }
    
    func registerUser(withEmail email:String, password: String, fullname: String) {
        guard let location = LocationManager.shared.userLocation else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("DEBUG: 회원가입 에러발생: \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: 회원가입 성공")
            
            if let result {
                let firebaseUser = result.user
                self.userSession = firebaseUser
                print("DEBUG: User id\(firebaseUser.uid))")
                let user = User(fullname: fullname,
                                email: email,
                                uid: firebaseUser.uid,
                                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
                                accountType: .driver)
                
                self.currentUser = user
                // 인코딩된 객체를 저장
                guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
                
                /* 위의 인코딩방식을 사용하지 않으면 아래방식처럼 직접 딕셔너리를 전송해야합니다.
                let data: [String: Any] = [
                    "fullname": fullname,
                    "email": email,
                    "uid": firebaseUser.uid
                ]
                */
                
                // users 컬렉션에 uid값(+회원정보) 저장
                Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
            }
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: 로그아웃 성공")
            self.userSession = nil
        } catch let error {
            print("DEBUG: 로그아웃 에러발생: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() {
        service.$user
            .sink { [weak self] user in
                guard let self
                else { return }
                
                self.currentUser = user
            }
            .store(in: &cancellables)
    }
                  
}
