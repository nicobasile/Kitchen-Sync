//
//  ItemListView.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation
import SwiftUI

struct ItemCell: View {
    @ObservedObject var itemCellVM: ItemCellViewModel
    var onCommit: (Result<Item, InputError>) -> Void = { _ in }
    
    var body: some View {
        HStack {
            Image(systemName: itemCellVM.completionStateIconName)
                .resizable()
                .frame(width: 30, height: 30)
                .onTapGesture {
                    self.itemCellVM.item.completed.toggle()
                }
            TextField("Enter item name", text: $itemCellVM.item.name,
                      onCommit: {
                        if !self.itemCellVM.item.name.isEmpty
                        { self.onCommit(.success(self.itemCellVM.item)) }
                        else
                        { self.onCommit(.failure(.empty)) } })
                .id(itemCellVM.id)
                .offset(x: 5, y: 1)
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 20))
        }
    }
}

enum InputError: Error {
    case empty
}

struct ItemListView : View {
    @ObservedObject var itemListVM = ItemListViewModel()
    @State var newItem = false
    @State var showSettingsScreen = false

    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Kitchen Sync")
                    .padding(.leading, 15.0)
                    .padding(.top, 10.0)
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 42))
                Spacer()
                Button(action: { self.showSettingsScreen.toggle() } ) {
                    Image("settings")
                        .resizable()
                        .padding(5.0)
                        .frame(width: 45, height: 45)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                }
                    .cornerRadius(10)
                    .padding(.trailing, 25.0)
                    .sheet(isPresented: $showSettingsScreen, content: { SettingsView() })
            }
            .offset(x: 5, y: 5)
            
            // Item List
            List {
                ForEach(itemListVM.itemCellViewModels) { itemCellVM in
                    ItemCell(itemCellVM: itemCellVM)
                }
                .onDelete { indexSet in
                    self.itemListVM.removeItems(atOffsets: indexSet)
                }
                if newItem {
                    ItemCell(itemCellVM: ItemCellViewModel.newItem()) { result in
                        if case .success(let item) = result {
                            self.itemListVM.addItem(item: item)
                        }
                        self.newItem.toggle()
                    }
                }
            }
            .offset(x: 5, y: -15)


            // Bottom Buttons
            HStack {
                Spacer()
                Button(action: { self.itemListVM.removeChecked() }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 33, height: 33)
                            .accentColor(Color(UIColor.systemGreen))
                        Text("Finish Trip")
                            .font(Font.custom("AppleSDGothicNeo-Medium", size: 24))
                            .accentColor(Color.black)
                            .offset(y: 1)
                    }
                }
                    .padding()
                Spacer()
                Button(action: { self.newItem.toggle() }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 33, height: 33)
                            .accentColor(Color(UIColor.systemGreen))
                        Text("New Item")
                            .font(Font.custom("AppleSDGothicNeo-Medium", size: 24))
                            .accentColor(Color.black)
                            .offset(y: 1)
                    }
                }
                    .padding()
                Spacer()
            }

        }
    }
    
    struct TextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 24))
       }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}

extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<SomeView: View>(to view: SomeView, when binding: Binding<Bool>) -> some View {
        modifier(NavigateModifier(destination: view, binding: binding))
    }
}

// MARK: - NavigateModifier
fileprivate struct NavigateModifier<SomeView: View>: ViewModifier {

    // MARK: Private properties
    fileprivate let destination: SomeView
    @Binding fileprivate var binding: Bool


    // MARK: - View body
    fileprivate func body(content: Content) -> some View {
        NavigationView {
            ZStack {
                content
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                NavigationLink(destination: destination
                    .navigationBarTitle("")
                    .navigationBarHidden(true),
                               isActive: $binding) {
                    EmptyView()
                }
            }
        }
    }
}
