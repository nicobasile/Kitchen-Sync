//
//  ItemRepository.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

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

class FirestoreItemRepository: BaseItemRepository, ItemRepository, ObservableObject {
    var db = Firestore.firestore()
  
    override init() {
        super.init()
        loadData()
    }
  
    private func loadData() {
        db.collection("items").order(by: "createdTime").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.items = querySnapshot.documents.compactMap { document -> Item? in
                    try? document.data(as: Item.self)
                }
            }
        }
    }
    
    func addItem(_ item: Item) {
        do {
            let _ = try db.collection("items").addDocument(from: item)
        }
        catch {
            print("There was an error while trying to save an item \(error.localizedDescription).")
        }
    }
        
    func removeItem(_ item: Item) {
        if let itemID = item.id {
            db.collection("items").document(itemID).delete { (error) in
                if let error = error {
                    print("Error removing document: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateItem(_ item: Item) {
        if let itemID = item.id {
            do {
                try db.collection("items").document(itemID).setData(from: item)
            }
            catch {
                print("There was an error while trying to update an item \(error.localizedDescription).")
            }
        }
    }
}
