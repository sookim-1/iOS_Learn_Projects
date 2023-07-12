//
//  LoginView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/12.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: -16) {
                    
                    // image
                    Image(systemName: "car")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 200)
                        .scaledToFill()
                    
                    // title
                    Text("UBER")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                    // input fields
                    
                    VStack(spacing: 32) {
                        // email
                        CustomInputField(text: $email, title: "이메일", placeholder: "이메일을 입력해주세요")
                    
                        // password
                        CustomInputField(text: $password, title: "비밀번호", placeholder: "비밀번호를 입력해주세요", isSecureField: true)
                        
                        Button {
                            
                        } label: {
                            Text("비밀번호를 잊어버리셨나요?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.top)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    // social sign in view
                    VStack {
                        // diveders + text
                        HStack(spacing: 24) {
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.white)
                                .opacity(0.5)
                            
                            Text("SNS 로그인")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                        
                        // sign up button
                        HStack(spacing: 24) {
                            Button {
                                
                            } label: {
                                Image(systemName: "f.circle")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                            }

                            Button {
                                
                            } label: {
                                Image(systemName: "g.circle")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    // sign in button
                    Button {
                        
                    } label: {
                        HStack {
                            Text("로그인")
                                .foregroundColor(.black)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    .background(Color(.white))
                    .cornerRadius(10)

                    Spacer()
                    
                    // sign up button
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Text("계정이 생각나지 않아요!")
                                .font(.system(size: 14))
                            
                            Text("회원가입")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
