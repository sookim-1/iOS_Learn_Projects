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
    case polylineAdded                  // 경로 표시한상태 - 추가 이유 ? locationSelected에서 처리하면 계속해서 UserMapRepresentable의 updateUIView메서드가 호출되고 LocationSearchViewModel에서 도착지주소가 업데이트 되므로
    case tripRequested                  // 여정요청상태
    case tripRejected                   // 여정거절상태
    case tripAccepted                   // 여정수락상태
}
