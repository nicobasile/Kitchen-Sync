//
//  SignUpView.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/17/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

struct SignUpView: View {
    @ObservedObject var itemListVM = ItemListViewModel()

    @Environment(\.presentationMode) var presentationMode
    @State private var group: String = ""
    @State private var password: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @State var errorText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            HStack {
                Spacer()
                Image("Logo")
                    .resizable()
                    .frame(width: 94, height: 10)
                    .aspectRatio(CGSize(width: 315, height: 502), contentMode: .fit)
                Spacer()
            }
            
            VStack(spacing: 20) {
                Text("Group Name")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                TextField("Enter a new group name", text: $group)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 10)
                Text("Password")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                SecureField("Enter a password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 10)
                if errorText != "" {
                    Text(errorText)
                        .foregroundColor(.white)
                }

                HStack {
                    Spacer()
                    Button(action: { self.registerUp(email: self.group, password: self.password) }) {
                        Text("Create Group").font(.headline).foregroundColor(.white)
                    }
                    Spacer()
                }
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
            }
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
                .padding(.bottom, keyboardHeight)
                .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        
            Spacer()
        }
        .padding(.horizontal)
        .background(Image("GroupBackground")
            .resizable()
            .clipped()
            .scaledToFill()
        .offset(x: -220, y: 0)
        )
        .edgesIgnoringSafeArea([.top, .bottom])
    }
    
    func registerUp(email: String, password: String) {
        // Remove all anonymous data before signing up
        self.itemListVM.removeAll()
        
        let fakeEmail = email + "@fakeEmail.com"
        
        Auth.auth()
            .createUser(withEmail: fakeEmail, password: password) { authResult, error in
                guard let _ = authResult?.user, error == nil else {
                    self.errorText = error?.localizedDescription ?? "Unknown Error"
                    if self.errorText == "The email address is badly formatted." {
                        self.errorText = "Group name cannot have spaces"
                    }
                    return
                }
                print("Created: \(email) + \(password)")
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
