//
//  InputVIew.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/2/24.
//

import SwiftUI

struct InputVIew: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    let isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField{
                SecureField(placeholder, text: $text)
                    .font(.system(size:14))
            } else{
                TextField(placeholder, text: $text)
                    .font(.system(size:14))
            }
            
            Divider()
            
        }
    }
}

#Preview {
    InputVIew(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
