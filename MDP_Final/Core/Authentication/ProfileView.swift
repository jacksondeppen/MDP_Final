//
//  ProfileView.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/2/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack{
                VStack{
                    Text(user.fullname)
                        .font(.title)
                    HStack{
                        Text("HOTW Wins:")
                        Text(String(user.wins))
                            .font(.subheadline)
                    }
                    HStack{
                        Text("GOTW Wins:")
                        Text(String(user.goblins))
                    }
                }
                Button {
                    viewModel.signOut()
                } label: {
                    HStack{
                        Text("SIGN OUT")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .padding(.top, 24)
                
                
                NavigationLink {
                    SubmitVoteView()
                } label: {
                    HStack{
                        Text("Submit Vote")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    
                }
                
                NavigationLink {
                    ViewVoting()
                } label: {
                    Text("The Votes are In")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                }
            }
        }
        
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
