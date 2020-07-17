//
//  AuthenticationService.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/17/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationService: ObservableObject {
    @Published var user: User?
    
    func signIn() {
        registerStateListener()
        Auth.auth().signInAnonymously()
    }
    
    private func registerStateListener() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Sign in state has changed.")
            self.user = user
            
            if let user = user {
                let anonymous = user.isAnonymous ? "anonymously " : ""
                print("User signed in \(anonymous)with user ID \(user.uid).")
            }
            else { print("User signed out.") }
        }
    }
}
