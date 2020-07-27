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
    @ObservedObject var itemListVM = ItemListViewModel()

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
        // Remove all data before signing up
        self.itemListVM.removeAll()
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let _ = authResult?.user, error == nil else {
                let errorText: String  = error?.localizedDescription ?? "unknown error"
                self.errorText = errorText
                return
            }
            print("Created: \(email) + \(password)")
            
            // Change _ above to user to make code below work
            /*let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            user.link(with: credential) { (authResult, error) in
                if error == nil { print("Anonymous account successfully upgraded") }
                else {
                    let errorText: String = error?.localizedDescription ?? "Unknown Error"
                    print("Error: \(errorText)")
                }
            }*/
        }
        /*// Delete empty anonymous user
        let user = Auth.auth().currentUser
        user?.delete { error in
            if error != nil { print("Error deleting anonymous user") }
            else { print("Deleted anonymous user") }
        }*/
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
