//
//  SignUpView.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/17/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import SwiftUI
import Firebase

struct SignUpView: View {
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
            
            Button(action: { self.registerUp(email: self.group, password: self.password) }) {
                Text("Sign Up")
            }
        }.frame(alignment: .center)
    }
    
    func registerUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print("Test?")
            guard let user = authResult?.user, error == nil else {
                print("Test??")
                let errorText: String  = error?.localizedDescription ?? "unknown error"
                self.errorText = errorText
                return
            }
            print("\(user.email!) created")
        }
        print("\(errorText)")
        print("Created: \(email)  +  \(password)")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
