//
//  DeveloperPreview.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/02.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    
    // extension에서는 프로퍼티를 저장할 수 없기 때문에 정적변수로 설정
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockUser = User(fullname: "Test",
                        email: "Test@gmail.com",
                        uid: NSUUID().uuidString,
                        coordinates: GeoPoint(latitude: 37.577949, longitude: 126.973046),
                        accountType: .passenger,
                        homeLocation: nil,
                        workLocation: nil)
}

