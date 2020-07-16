//
//  Task.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation

struct Item: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var completed: Bool
}

var first: Item = Item(name: "Eggs", completed: false)
var second = Item(name: "Bread", completed: false)
var third = Item(name: "Milk", completed: false)

#if DEBUG
let testItems = [
    Item(name: "Eggs", completed: false),
    Item(name: "Bread", completed: false),
    Item(name: "Milk", completed: false)
]
#endif
