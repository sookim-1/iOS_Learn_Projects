//
//  MapViewActionButton.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import SwiftUI

struct MapViewActionButton: View {
    
    @Binding var mapState: MapViewState
    @Binding var showSideMenu: Bool
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("메인 버튼 클릭: No Input")
            showSideMenu.toggle()
        case .searchingForLocation:
            print("메인 버튼 클릭: SearchingForLocation")
            mapState = .noInput
        case .locationSelected,
                .polylineAdded,
                .tripRejected,
                .tripAccepted,
                .tripRequested:
            print("메인 버튼 클릭: locationSelected")
            mapState = .noInput
            viewModel.selectedUberLocation = nil
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation,
                .locationSelected,
                .polylineAdded,
                .tripRejected,
                .tripRequested,
                .tripAccepted:
            return "arrow.left"
        }
    }
    
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput), showSideMenu: .constant(false))
            .environmentObject(LocationSearchViewModel())
            .environmentObject(AuthViewModel())
    }
}
