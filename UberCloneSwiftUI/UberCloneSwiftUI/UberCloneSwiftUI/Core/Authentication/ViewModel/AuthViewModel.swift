//
//  AuthViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/12.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    
    // Firebase 인증 세션 : 로그인 한 사용자에 대한 정보들 저장하고 해당 값으로 로그인 여부 판별
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        userSession = Auth.auth().currentUser
    }
    
    func registerUser(withEmail email:String, password: String, fullname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("DEBUG: 회원가입 에러발생: \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: 회원가입 성공")
            
            if let result {
                print("DEBUG: User id\(result.user.uid))")
            }
        }
    }
                  
}
