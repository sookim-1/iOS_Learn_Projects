//
//  SideMenuOptionViewModel.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/13.
//

import Foundation

enum SideMenuOptionViewModel: Int, CaseIterable, Identifiable {
    case trips
    case wallet
    case settings
    case messages
    
    var title: String {
        switch self {
        case .trips: return "여정"
        case .wallet: return "지갑"
        case .settings: return "설정"
        case .messages: return "채팅"
        }
    }
    
    var imageName: String {
        switch self {
        case .trips: return "list.bullet.rectangle"
        case .wallet: return "creditcard"
        case .settings: return "gear"
        case .messages: return "bubble.left"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
    
}
