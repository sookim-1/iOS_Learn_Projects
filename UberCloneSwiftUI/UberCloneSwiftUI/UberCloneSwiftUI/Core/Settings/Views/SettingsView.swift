//
//  SettingsView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/13.
//

import SwiftUI

struct SettingsView: View {
    
    private let user: User
    @EnvironmentObject var viewModel: AuthViewModel
    
    init(user: User) {
        self.user = user
    }
    
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
                            Text(user.fullname)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(user.email)
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
                    .padding(8)
                }
                
                Section("즐겨찾기") {
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        // 각각의 버튼이 같은 곳을 향하기 때문 navigationDestination을 사용하지 않는다.
                        NavigationLink {
                            SavedLocationSearchView()
                        } label: {
                            SavedLocationRowView(viewModel: viewModel)
                        }
                    }
                }
                
                Section("설정") {
                    SettingsRowView(imageName: "bell.circle.fill", title: "알림", tintColor: Color(.systemPurple))
                    
                    SettingsRowView(imageName: "creditcard.circle.fill", title: "결제수단", tintColor: Color(.systemBlue))
                }
                
                Section("계정") {
                    SettingsRowView(imageName: "dollarsign.circle.fill", title: "드라이버로 전환", tintColor: Color(.systemGreen))
                    
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "로그아웃", tintColor: Color(.systemRed))
                        .onTapGesture {
                            viewModel.signout()
                        }
                }
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(user: User(fullname: "Test", email: "test@gmail.com", uid: "123456"))
                .environmentObject(AuthViewModel())
        }
    }
}
