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
                .frame(width: 20, height: 20)
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
        NavigationView {
            VStack {
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
                // Bottom Buttons
                HStack {
                    Spacer()
                    Button(action: { /*self.items.removeAll()*/ }) {
                        Text("Finish Trip")
                    }
                        .padding()
                        .accentColor(Color(UIColor.systemRed))
                    Spacer()
                    Button(action: { self.newItem.toggle() }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("New Item")
                        }
                    }
                        .padding()
                        .accentColor(Color(UIColor.systemRed))
                    Spacer()
                }
            }
            .navigationBarTitle("Kitchen Sync")
            .navigationBarItems(trailing:
              Button(action: {
                self.showSettingsScreen.toggle()
              }) {
                Text("Temp")
              }
            )
            .sheet(isPresented: $showSettingsScreen) { SettingsView() }
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}


