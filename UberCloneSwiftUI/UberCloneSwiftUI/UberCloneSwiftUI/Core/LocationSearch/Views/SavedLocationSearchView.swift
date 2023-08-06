//
//  SavedLocationSearchView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/13.
//

import SwiftUI

struct SavedLocationSearchView: View {
    
    // EnvironMentObject를 사용하지 않는 이유? EnvironMentObject를 사용하면 검색결과가 변경되어서 재사용하는 경우 동일한 인스턴스를 가지고 있어서 다른화면에서도 값이 일정하지 않기 때문
    @StateObject var viewModel = HomeViewModel()
    let config: SavedLocationViewModel
    
    var body: some View {
        VStack {
            TextField("주소 검색", text: $viewModel.queryFragment)
                .frame(height: 32)
                .padding(.leading)
                .background(Color(.systemGray5))
                .padding()
            
            Spacer()
            
            LocationSearchResultsView(viewModel: viewModel, config: .saveLocation(config))
        }
        .navigationTitle(config.subtitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SavedLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SavedLocationSearchView(config: .home)
        }
    }
}
