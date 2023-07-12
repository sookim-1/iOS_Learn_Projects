//
//  CustomInputField.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/07/12.
//

import SwiftUI

struct CustomInputField: View {
    
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        // inputField
        VStack(alignment: .leading, spacing: 12) {
            // title
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .font(.footnote)
            
            // text fields
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }
        
            // divider
            Rectangle()
                .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
        }
    }
}

struct CustomInputField_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputField(text: .constant(""), title: "이메일", placeholder: "이메일을 입력해주세요")
    }
}
