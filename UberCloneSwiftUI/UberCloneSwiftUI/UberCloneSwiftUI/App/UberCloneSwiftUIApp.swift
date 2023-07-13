//
//  UberCloneSwiftUIApp.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
}

@main
struct UberCloneSwiftUIApp: App {
    // * 해당 뷰모델을 홈화면, 검색화면 모두 사용해야 하기 때문에 EnvironmentObject로 처음 초기화 이후에 각각의 화면에서 사용
    // * 이렇게 하지 않으면, 각각의 화면에서 인스턴스를 생성할시 각각의 인스턴스는 다른 인스턴스이기 때문에 값을 전달하지 않는다.
    @StateObject var locationViewModel = LocationSearchViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
                .environmentObject(authViewModel)
        }
    }
    
}

