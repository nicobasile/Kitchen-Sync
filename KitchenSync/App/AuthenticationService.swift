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
    
    /*init() {
        print("init()")
        registerStateListener()
    }
    
    func signIn() {
        print("signIn()")
        if Auth.auth().currentUser == nil { Auth.auth().signInAnonymously() }
    }
    
    private func registerStateListener() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Sign in state has changed.")
        self.user = user
        
        if let user = user {
          let anonymous = user.isAnonymous ? "anonymously " : ""
          print("User signed in \(anonymous)with user ID \(user.uid).")
        }
        else {
          print("User signed out.")
        }
      }
    }*/
        
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        print("init()")
        registerStateListener()
    }

    private func registerStateListener() {
        if let handle = handle { Auth.auth().removeStateDidChangeListener(handle) }

        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Sign in state has changed.")
            self.user = user
          
            if let user = user {
                let anonymous = user.isAnonymous ? "anonymously " : ""
                print("User signed in \(anonymous)with user ID \(user.uid). Email: \(user.email ?? "(empty)"), display name: [\(user.displayName ?? "(empty)")]")
            }
            else {
                print("User signed out.")
                self.signIn()
            }
        }
    }
    
    func signIn() {
        if Auth.auth().currentUser == nil { Auth.auth().signInAnonymously() }
    }

    func signOut() {
        do { try Auth.auth().signOut() }
        catch { print("Error when trying to sign out: \(error.localizedDescription)") }
    }
}
