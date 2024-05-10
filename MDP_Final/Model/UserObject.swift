//
//  UserObject.swift
//  MDP_Final
//
//  Created by Jackson Deppen on 5/2/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    var wins: Int
    var goblins: Int
    var winVoteName: String
    var goblinVoteName: String
    var reason: String
}


//struct Vote: Codable {
//    let voterID: String
//    let targetUserID: String
//    let voteType: String
//    
//    func submitToFirebase() {
//        let db = Firestore.firestore()
//        db.collection("votes").addDocument(data: [
//            "voterID": voterID,
//            "targetUserID": targetUserID,
//            "voteType": voteType
//        ])
//    }
//}

//extension User {
//    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Jackson Depen", email: "test@mail", wins: 0, goblins: 0)
//}


