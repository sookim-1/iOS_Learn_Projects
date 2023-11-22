//
//  LocationSearchActivationView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/02.
//

import SwiftUI

struct LocationSearchActivationView: View {
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
            
            Text("어디로 가시나요?")
                .foregroundColor(Color(.darkGray))
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black, radius: 6)
        )
    }
    
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
