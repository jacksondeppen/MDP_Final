//
//  RegistrationView.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/2/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmpassword = ""
    @State private var wins = 0
    @State private var goblins = 0
    @State private var winVoteName = ""
    @State private var goblinVoteName = ""
    @State private var reasoning = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    var body: some View {
        
        
        VStack{
            InputVIew(text: $fullname, title: "Full Name", placeholder: "Jane Doe")
                .autocapitalization(.none)
            
            InputVIew(text: $email, title: "Email Address", placeholder: "name@example.com")
                .autocapitalization(.none)
            
            InputVIew(text: $password, title: "Password", placeholder: "Enter your password")
            
            InputVIew(text: $confirmpassword, title: "Confirm Password", placeholder: "Re-enter your password")
        
        }
        .padding(.horizontal)
        .padding(.top, 12)
        
        
        
        Button {
            Task {
                try await viewModel.createUser(withEmail: email, password: password, fullname: fullname, wins: wins, goblins: goblins)
            }
        } label: {
            HStack{
                Text("SIGN UP")
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
            LoginView()
        } label: {
            Text("Go Back")
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel())
}
