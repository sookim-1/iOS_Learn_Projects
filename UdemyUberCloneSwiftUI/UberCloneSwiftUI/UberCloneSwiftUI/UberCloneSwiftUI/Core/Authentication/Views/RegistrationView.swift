//
//  RegistrationView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/12.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                }
                
                Text("회원가입")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                Spacer()
                
                VStack {
                    VStack(spacing: 56) {
                        CustomInputField(text: $fullname, title: "이름", placeholder: "이름을 입력해주세요")
                        CustomInputField(text: $email, title: "이메일", placeholder: "이메일을 입력해주세요")
                        CustomInputField(text: $password, title: "비밀번호", placeholder: "비밀번호를 입력해주세요", isSecureField: true)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    // sign in button
                    Button {
                        viewModel.registerUser(withEmail: email, password: password, fullname: fullname)
                    } label: {
                        HStack {
                            Text("회원가입")
                                .foregroundColor(.black)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    .background(Color(.white))
                    .cornerRadius(10)
                    
                    Spacer()
                }
                
                
            }
            .foregroundColor(.white)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthViewModel())
    }
}
