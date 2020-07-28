//
//  SignInView.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/17/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

struct SignInView: View {
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
                TextField("Enter an existing group name", text: $group)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 10)
                Text("Password")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                SecureField("Enter a password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 10)
                
                HStack {
                    Spacer()
                    Button(action: { self.registerIn(email: self.group, password: self.password) }) {
                        Text("Join Group").font(.headline).foregroundColor(.white)
                    }
                    Spacer()
                }
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                Text("").padding(.vertical, -10)
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
    
    func registerIn(email: String, password: String) {
        // Remove all data before signing in
        self.itemListVM.removeAll()

        let fakeEmail = email + "@fakeEmail.com"

        Auth.auth().signIn(withEmail: fakeEmail, password: password) { user, error in
            if let error = error {
                self.errorText = error.localizedDescription
                print("Error: \(self.errorText)")
                return
            }
            guard user != nil else { return }
        }
        print("Joined: \(email)  +  \(password)")
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
