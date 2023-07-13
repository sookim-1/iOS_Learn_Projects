//
//  SavedLocationViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/13.
//

import Foundation

enum SavedLocationViewModel: Int, CaseIterable, Identifiable {
    case home
    case work
    
    var title: String {
        switch self {
        case .home: return "집"
        case .work: return "직장"
        }
    }
    
    var imageName: String {
        switch self {
        case .home: return "house.circle.fill"
        case .work: return "archivebox.circle.fill"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home: return "추가하기"
        case .work: return "추가하기"
        }
    }
    
    var id: Int { return self.rawValue }
    
    
}
