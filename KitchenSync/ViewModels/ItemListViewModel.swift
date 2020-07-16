//
//  ItemListViewModel.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation
import Combine

class ItemListViewModel: ObservableObject {
    @Published var itemCellViewModels = [ItemCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.itemCellViewModels = testItems.map { item in
            ItemCellViewModel(item: item)
        }
    }
    
    func addItem(item: Item) {
        itemCellViewModels.append(ItemCellViewModel(item: item))
    }
    func removeItem(atOffsets indexSet: IndexSet) {
        itemCellViewModels.remove(atOffsets: indexSet)
    }
}
