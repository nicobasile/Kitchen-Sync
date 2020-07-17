//
//  Task.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Item: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var completed: Bool
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?
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
