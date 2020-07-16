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
    var items: [Item] = testItems

    var body: some View {
         VStack {
             // Header
             Text("Kitchen Sync");
            
             // Item List
             List {
                 ForEach(self.items) { item in
                    ItemCell(itemCellVM: )
                 }
                 //.onDelete(perform: self.removeItem)
                 .onTapGesture { print("Tap") }
             }
            
             // New Item
             /*Form {
                 /*TextField("New Entry", text: $newItem.name, onCommit: self.addItem)*/
                TextField("New Entry", text: "Temp")
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()
             }*/
            
             // Bottom Buttons
             HStack {
                 Button(action: { /*self.items.removeAll()*/ }) {
                     Text("Finish Grocery Trip")
                 }
                 .padding()
                 .accentColor(Color(UIColor.systemRed))
                Button(action: { /*self.items.append(Item(name: "Cookies", completed: false))*/ }) {
                    Text("PlaceHolder")
                 }
                 .padding()
                 .accentColor(Color(UIColor.systemRed))
            }
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}


