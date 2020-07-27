//
//  ItemListViewModel.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation
import Combine
import Resolver

class ItemListViewModel: ObservableObject {
    @Published var itemRepository: ItemRepository = Resolver.resolve()
    @Published var itemCellViewModels = [ItemCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        itemRepository.$items.map { items in
            items.map { item in
                ItemCellViewModel(item: item)
            }
        }
        .assign(to: \.itemCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func removeItems(atOffsets indexSet: IndexSet) {
        let viewModels = indexSet.lazy.map { self.itemCellViewModels[$0] }
        viewModels.forEach { itemCellViewModel in
            itemRepository.removeItem(itemCellViewModel.item)
        }
    }
    
    func removeChecked() {
        for item in itemRepository.items {
            if item.completed {
                print("Deleted \(item.name)")
                itemRepository.removeItem(item)
            }
        }
    }
    
    func removeAll() {
        print("Deleted all old items")
        for item in itemRepository.items {
            itemRepository.removeItem(item)
        }
    }
    
    func addItem(item: Item) {
        itemRepository.addItem(item)
    }
}
