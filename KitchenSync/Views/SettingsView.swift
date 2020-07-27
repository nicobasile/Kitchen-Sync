//
//  SettingsView.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/17/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var showSignUp = false
    @State var showSignIn = false

    var body: some View {
        NavigationView {
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 100)
                    .padding(.top, 20)

                Text("Thanks for using")
                    .font(.title)

                Text("Kitchen Sync")
                    .font(.title)
                    .fontWeight(.semibold)
              
                Form {
                    Section {
                        NavigationLink(destination: Text("About Page") ) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("About")
                            }
                        }
                    }
                    
                    Section(footer: footer) {
                        HStack {
                            if settingsViewModel.isAnonymous {
                                Spacer()
                                
                                /*Button(action: { self.showSignUp = true }) {
                                    Text("Create a group")
                                }
                                .padding()
                                .sheet(isPresented: $showSignUp) { SignUpView() }
                                
                                Spacer()
                                
                                Button(action: { self.showSignIn = true }) {
                                    Text("Join a group")
                                }
                                .padding()
                                .sheet(isPresented: $showSignIn) { SignInView() }*/
                                
                                Button(action: {}) {
                                    Text("Create a group")
                                }
                                    .onTapGesture { self.showSignUp.toggle() }
                                    .padding()
                                    .sheet(isPresented: $showSignUp) { SignUpView() }
                                
                                Spacer()
                                
                                Button(action: { }) {
                                    Text("Join a group")
                                }
                                    .onTapGesture { self.showSignIn.toggle() }
                                    .padding()
                                    .sheet(isPresented: $showSignIn) { SignInView() }
                                
                                Spacer()
                            }
                            else {
                                Button(action: { self.settingsViewModel.logout() }) {
                                    HStack {
                                        Spacer()
                                        Text("Logout")
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Settings", displayMode: .inline)
                .navigationBarItems(trailing:
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) { Text("Done") })
            }
        }
    }
    
    var footer: some View {
      HStack {
        Spacer()
        if settingsViewModel.isAnonymous {
          Text("You are not part of a group yet")
        }
        else {
          Text("Active group: \(self.settingsViewModel.email)")
        }
        Spacer()
      }
    }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
