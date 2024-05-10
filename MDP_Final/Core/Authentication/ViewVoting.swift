//
//  ViewVoting.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/8/24.
//

import SwiftUI

struct ViewVoting: View {
    @State private var usersWithVotes: [User] = []
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        List(usersWithVotes, id: \.id) { user in
            VStack(alignment: .leading) {
                Text("Full Name: \(user.fullname)")
                Text("Email: \(user.email)")
                Text("Wins: \(user.wins)")
                Text("Goblins: \(user.goblins)")
                Text("HOTW Nomination: \(user.winVoteName)")
                Text("GOTW Nomination: \(user.goblinVoteName)")
                Text("Reason: \(user.reason)")
            }
        }
        .onAppear {
            // Fetch all users' data when the view appears
            viewModel.fetchAllUsersDataWithVotes { fetchedUsers in
                // Update the state with the fetched users
                usersWithVotes = fetchedUsers
            }
        }
        NavigationLink{
            ViewWinner()
        } label: {
            Text("Calculate Results")
        }
    }
}

#Preview {
    ViewVoting()
        .environmentObject(AuthViewModel())

}
