////
////  Submit Vote View.swift
////  MDP_Final
////
////  Created by Jackson Deppen on 5/7/24.
////

import SwiftUI

struct SubmitVoteView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var houseMate = ""
    @State private var goblin = ""
    @State private var reason = ""
//    
    var body: some View {
        if viewModel.currentUser != nil {
            VStack{
                Text("Submit your Vote for Housemate and Goblin of the Week")
                
                TextField("Housemate of the Week", text: $houseMate)
                TextField("Goblin of the Week", text: $goblin)
                TextField("Reasoning: ", text: $reason)
                
                
                Button {
                    Task {
                        try await viewModel.submitVote(winVoteName: houseMate, goblinVoteName: goblin, reason: reason)
                    }
                } label: {
                    HStack{
                        Text("Submit Vote")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .padding(.top, 24)
                
            }
            
        }
        
    }
}

#Preview {
    SubmitVoteView()
        .environmentObject(AuthViewModel())
}
