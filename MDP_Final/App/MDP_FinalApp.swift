//
//  MDP_FinalApp.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/2/24.
//

import SwiftUI
import Firebase

@main
struct MDP_FinalApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
