//
//  AuthViewModel.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/2/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift



@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var usersWithVotes: [User] = []
    @Published var HOTWName: String = "No winner - from auth view"
    @Published var goblinName: String = "No goblin -  from auth view"
    
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {print("DEBUG: Failed to log in")}
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, wins: Int, goblins: Int) async throws{
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, wins: wins, goblins: goblins, winVoteName: "", goblinVoteName: "", reason: "")
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            
        } catch {
            print("Failed to create user with error")
        }
    }
    

    
    
    func submitVote(winVoteName: String, goblinVoteName: String, reason: String) async throws{
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard var currentUser = self.currentUser else { return }
            
            // Update the fields
            currentUser.winVoteName = winVoteName
            currentUser.goblinVoteName = goblinVoteName
            currentUser.reason = reason
            
            // Encode the updated user data
            let encodedUser = try Firestore.Encoder().encode(currentUser)
            
            // Update the user data in Firestore
            try await Firestore.firestore().collection("users").document(uid).setData(encodedUser, merge: true)
            
            // Update the currentUser property
            self.currentUser = currentUser
            await fetchUser()
            
        } catch {
            print("Failed to submit vote with error: \(error.localizedDescription)")
        }
    }


    // Update AuthViewModel to fetch all users' data
    func fetchAllUsersDataWithVotes(completion: @escaping ([User]) -> Void) {
            let db = Firestore.firestore()

            db.collection("users").getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching users: \(error)")
                    completion([])
                    return
                }

                var usersWithVotes: [User] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let fullname = data["fullname"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let wins = data["wins"] as? Int ?? 0
                    let goblins = data["goblins"] as? Int ?? 0
                    let winVoteName = data["winVoteName"] as? String ?? ""
                    let goblinVoteName = data["goblinVoteName"] as? String ?? ""
                    let reason = data["reason"] as? String ?? ""
                    let user = User(id: id, fullname: fullname, email: email, wins: wins, goblins: goblins, winVoteName: winVoteName, goblinVoteName: goblinVoteName, reason: reason)
                    usersWithVotes.append(user)
                }
                print("Fetched users: \(usersWithVotes)")
                
                // Once all users' data is fetched, call the completion handler
                completion(usersWithVotes)
            }
        }


    func determineWinnerAndLoser() {
        let db = Firestore.firestore()

        db.collection("users").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }

            var usersWithVotes: [User] = []
            for document in querySnapshot!.documents {
                let data = document.data()
                let id = data["id"] as? String ?? ""
                let fullname = data["fullname"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let wins = data["wins"] as? Int ?? 0
                let goblins = data["goblins"] as? Int ?? 0
                let winVoteName = data["winVoteName"] as? String ?? ""
                let goblinVoteName = data["goblinVoteName"] as? String ?? ""
                let reason = data["reason"] as? String ?? ""
                let user = User(id: id, fullname: fullname, email: email, wins: wins, goblins: goblins, winVoteName: winVoteName, goblinVoteName: goblinVoteName, reason: reason)
                usersWithVotes.append(user)
            }

            // Update usersWithVotes property
            self.usersWithVotes = usersWithVotes

            // Proceed with winner and loser determination
            guard !self.usersWithVotes.isEmpty else {
                print("usersWithVotes is empty, returning early")
                return
            }

            // Determine the winner and loser
            var winVotesCount: [String: Int] = [:]
            var goblinVotesCount: [String: Int] = [:]

            for user in self.usersWithVotes {
                if !user.winVoteName.isEmpty {
                    winVotesCount[user.winVoteName, default: 0] += 1
                }
                if !user.goblinVoteName.isEmpty {
                    goblinVotesCount[user.goblinVoteName, default: 0] += 1
                }
            }

            let winnerName = winVotesCount.max { $0.value < $1.value }?.key
            let loserName = goblinVotesCount.max { $0.value < $1.value }?.key

            DispatchQueue.main.async {
                        self.HOTWName = winnerName ?? "No winner"
                        self.goblinName = loserName ?? "No Loser"

                        // Update wins and losses for the winner and loser
                        if let winner = self.usersWithVotes.first(where: { $0.fullname == self.HOTWName }) {
                            self.updateWinsAndLosses(for: winner, win: true)
                        }
                        if let loser = self.usersWithVotes.first(where: { $0.fullname == self.goblinName }) {
                            self.updateWinsAndLosses(for: loser, win: false)
                        }
                    }

            print("Winner: \(self.HOTWName)")
            print("Loser: \(self.goblinName)")
        }
    }

    
    func updateWinsAndLosses(for user: User, win: Bool) {
        let db = Firestore.firestore()
        let newWins = win ? user.wins + 1 : user.wins
        let newLosses = !win ? user.goblins + 1 : user.goblins
        
        // Update wins and losses in Firestore
        db.collection("users").document(user.id).setData(["wins": newWins, "goblins": newLosses], merge: true) { error in
            if let error = error {
                print("Error updating wins and losses: \(error)")
            } else {
                print("Wins and losses updated successfully for \(user.fullname)")
            }
        }
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: current user is")
    }
}


