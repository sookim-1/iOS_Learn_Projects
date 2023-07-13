//
//  SideMenuView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/13.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack {
            // header view
            VStack(alignment: .leading, spacing: 32) {
                // user info
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 64, height: 64)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("이름")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("이메일")
                            .accentColor(.black)
                            .opacity(0.77)
                    }
                }
                
                // become a driver
                VStack(alignment: .leading, spacing: 16) {
                    Text("여러 기능 사용해보기")
                        .font(.footnote)
                    .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "dollarsign.square")
                            .font(.title2)
                            .imageScale(.medium)
                        
                        Text("운전을 통해 돈벌기")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(6)
                    }
                }
                
                // option list
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
            
            Spacer()
        }
        .padding(.top, 32)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
