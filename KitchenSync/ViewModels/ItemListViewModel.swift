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
    
    func addItem(item: Item) {
        itemCellViewModels.append(ItemCellViewModel(item: item))
    }
    func removeItem(atOffsets indexSet: IndexSet) {
        itemCellViewModels.remove(atOffsets: indexSet)
    }
}
