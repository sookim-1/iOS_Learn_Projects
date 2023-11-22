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
    
    var databaseKey: String {
        switch self {
        case .home: return "homeLocation"
        case .work: return "workLocation"
        }
    }
    
    func subtitle(forUser user: User) -> String {
        switch self {
        case .home:
            if let homeLocation = user.homeLocation {
                return homeLocation.title
            } else {
                return "추가하기"
            }
        case .work:
            if let workLocation = user.workLocation {
                return workLocation.title
            } else {
                return "추가하기"
            }
        }
    }
    
    var id: Int { return self.rawValue }
    
    
}
