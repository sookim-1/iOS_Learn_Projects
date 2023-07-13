//
//  SettingsView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/13.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            List {
                Section {
                    // user info header
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Test")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text("test@gmail.com")
                                .font(.system(size: 14))
                                .accentColor(Color.theme.primaryTextColor)
                                .opacity(0.77)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("즐겨찾기") {
                    SavedLocationRowView(imageName: "house.circle.fill", title: "집", subtitle: "추가하기")
                    
                    SavedLocationRowView(imageName: "archivebox.circle.fill", title: "직장", subtitle: "추가하기")
                }
                
                Section("설정") {
                    SettingsRowView(imageName: "bell.circle.fill", title: "알림", tintColor: Color(.systemPurple))
                    
                    SettingsRowView(imageName: "creditcard.circle.fill", title: "결제수단", tintColor: Color(.systemBlue))
                }
                
                Section("계정") {
                    SettingsRowView(imageName: "dollarsign.circle.fill", title: "드라이버로 전환", tintColor: Color(.systemGreen))
                    
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "로그아웃", tintColor: Color(.systemRed))
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
