//
//  LocationSearchResultsView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/14.
//

import SwiftUI

struct LocationSearchResultsView: View {
    // 해당 화면 재사용 - 지도상태와 독립적으로 분리하기 위해 config를 통해 어디서 사용하는지 파악합니다. 파악한 기준으로 화면별 동작을 정의합니다.
    
    // EnvironMentObject를 사용하지 않는 이유? EnvironMentObject를 사용하면 검색결과가 변경되어서 재사용하는 경우 동일한 인스턴스를 가지고 있어서 다른화면에서도 값이 일정하지 않기 때문
    @StateObject var viewModel: HomeViewModel
    let config: LocationResultsViewConfig
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.results, id: \.self) { result in
                    LocationSearchResultCell(title: result.title, subTitle: result.subtitle)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                viewModel.selectLocation(result, config: config)
                                // 재사용을 위해 지도상태를 해당 화면이 가지고 있으면 밀접하게 결합되어서 다른 곳으로 이동해야합니다.
                                // mapState = .locationSelected
                            }
                        }
                }
            }
        }
    }
    
}
