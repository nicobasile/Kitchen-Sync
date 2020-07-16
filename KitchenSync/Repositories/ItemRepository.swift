//
//  ItemRepository.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation

class BaseItemRepository {
    @Published var items = [Item]()
}

protocol ItemRepository: BaseItemRepository {
    func addItem(_ item: Item)
    func removeItem(_ item: Item)
    func updateItem(_ item: Item)
}

class TestDataItemRepository: BaseItemRepository, ItemRepository, ObservableObject {
    override init() {
        super.init()
        self.items = testItems
    }
     
    func addItem(_ item: Item) {
        items.append(item)
    }
     
    func removeItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
     
    func updateItem(_ item: Item) {
        if let index = self.items.firstIndex(where: { $0.id == item.id } ) {
            self.items[index] = item
        }
    }
}
