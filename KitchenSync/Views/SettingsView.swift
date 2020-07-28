//
//  SettingsView.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/17/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var showSignUp = false
    @State var showSignIn = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Spacer()
                Image("Logo")
                    .resizable()
                    //.clipped()
                    //.scaledToFit()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                    //.padding(.horizontal, 100)
                    //.padding(.top, 20)
                    .cornerRadius(50)
                
                Text("Thanks for using")
                    .font(.title)

                Text("Kitchen Sync")
                    .font(.title)
                    .fontWeight(.semibold)
              
                Form {
                    Section(footer: footer) {
                        VStack {
                            Text("Group Data Syncing")
                                .font(.title).padding(.top, 10)
                            Text("All items in a group will be automatically synced across all members of the group")
                                .padding().padding(.top, -5)
                            HStack {
                                if settingsViewModel.isAnonymous {
                                    Spacer()
                                
                                    Button(action: {}) {
                                        Text("Create Group")
                                            .padding()
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .onTapGesture { self.showSignUp.toggle() }
                                        .padding(.bottom, 10)
                                        .sheet(isPresented: $showSignUp) { SignUpView() }
                                    
                                    Spacer()
                                    
                                    Button(action: { }) {
                                        Text("   Join Group   ")
                                            .padding()
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .onTapGesture { self.showSignIn.toggle() }
                                        .padding(.bottom, 10)
                                        .sheet(isPresented: $showSignIn) { SignInView() }
                                    
                                    Spacer()
                                }
                                else {
                                    Spacer()
                                    Button(action: { self.settingsViewModel.logout() }) {
                                            Text("   Logout   ")
                                                .padding()
                                                .font(.headline)
                                                .foregroundColor(.white)
                                    }
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .padding(.bottom, 10)
                                    Spacer()
                                }
                            }
                        }
                    }
                    Section {
                        NavigationLink(destination:
                            VStack(alignment: .center, spacing: 20) {
                                Spacer()
                                VStack(spacing: 10) {
                                    Text("Kitchen Sync")
                                        .font(Font.custom("Arial-BoldMT", size: 42))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Made by Nicolas Basile")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text("For more of my work, visit:")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text("nicobasile.com")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text("linkedin.com/nicobasile")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                    .padding()
                                    .background(Color.gray.opacity(0.8))
                                    .cornerRadius(10)
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
                            ) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("About")
                            }
                                .padding(.leading)
                        }
                            .padding(.trailing)
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
                Text("Active group: \(groupName())")
            }
            Spacer()
        }
    }
    
    func groupName() -> String {
        let removeEmailIndex = settingsViewModel.email.firstIndex(of: "@") ?? settingsViewModel.email.endIndex
        let groupName = settingsViewModel.email[..<removeEmailIndex]
        return String(groupName).capitalizingFirstLetter()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
