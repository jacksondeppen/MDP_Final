//
//  ViewWinner.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/8/24.
//

import SwiftUI

struct ViewWinner: View {
    @EnvironmentObject var viewModel: AuthViewModel
//    @State private var winnerName: String = "No winner"
//    @State private var loserName: String = "No goblin"
    @State private var showResults: Bool = false
    
    var body: some View {
        
        
        Button {
            Task {
                
                viewModel.determineWinnerAndLoser()
                showResults = true
            }
        } label: {
            Text("Show Results")
        }
        
        if showResults {
            VStack {
                Text("Housemate of the Week: \(viewModel.HOTWName)")
                Text("Goblin of the Week: \(viewModel.goblinName)")
            }
        }
    }
}

#Preview {
    ViewWinner()
        .environmentObject(AuthViewModel())
}
