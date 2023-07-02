//
//  HomeView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        UberMapViewRepresentable()
            .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
