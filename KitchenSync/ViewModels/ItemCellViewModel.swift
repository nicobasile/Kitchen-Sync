//
//  ItemCellViewModel.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation
import Combine

class ItemCellViewModel: ObservableObject, Identifiable {
    @Published var item: Item
    
    var id: String = ""
    @Published var completionStateIconName = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    static func newItem() -> ItemCellViewModel {
        ItemCellViewModel(item: Item(name: "", completed: false))
    }
    
    init(item: Item) {
        self.item = item
        
        $item
          .map { $0.completed ? "checkmark.circle.fill" : "circle" }
          .assign(to: \.completionStateIconName, on: self)
          .store(in: &cancellables)

        $item
          .map { $0.id }
          .assign(to: \.id, on: self)
          .store(in: &cancellables)
    }
}
