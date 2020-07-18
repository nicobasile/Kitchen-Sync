//
//  SignInView.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/17/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var group: String = ""
    @State var password: String = ""
    @State var errorText: String = ""
        
    var body: some View {
        VStack {
            Text("Email")
            TextField("user@domain.com", text: $group)
        
            Text("Password")
            SecureField("Enter a password", text: $password)
            
            Button(action: { self.registerIn(email: self.group, password: self.password) }) {
                Text("Sign In")
            }
        }.frame(alignment: .center)
    }
    
    func registerIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                self.errorText = error.localizedDescription
                return
            }
            guard user != nil else { return }
        }
        print("\(errorText)")
        print("Joined: \(email)  +  \(password)")
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
