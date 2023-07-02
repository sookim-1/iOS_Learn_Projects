//
//  MapViewState.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import Foundation

enum MapViewState {
    case noInput                        // 미입력상태
    case searchingForLocation           // 검색화면상태
    case locationSelected               // 검색주소 선택상태
}
