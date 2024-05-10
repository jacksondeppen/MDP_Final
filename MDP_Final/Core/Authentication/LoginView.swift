//
//  LoginView.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/2/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                //image
                HStack {
                    Image("happyHouse")
                        .resizable()
                    Image("angryGoblin")
                        .resizable()
                }
                
                Spacer()
                
                //form fields
                VStack{
                    InputVIew(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputVIew(text: $password, title: "Password", placeholder: "Enter your password")
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack{
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .padding(.top, 24)
                            
                
                
                
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                } label: {
                    HStack{
                        Text("No Account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
