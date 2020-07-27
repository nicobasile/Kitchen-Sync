//
//  ItemRepository.swift
//  KitchenSync
//
//  Created by Nico Basile on 7/16/20.
//  Copyright © 2020 Nico Basile. All rights reserved.
//

import Foundation

import Combine
import Resolver

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
  
    @Injected var authenticationService: AuthenticationService
    var itemsPath: String = "items"
    var userId: String = "unknown"
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        authenticationService.$user
          .compactMap { user in
            user?.uid
          }
          .assign(to: \.userId, on: self)
          .store(in: &cancellables)
        
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.loadData()
            }
            .store(in: &cancellables)
    }
  
    private func loadData() {
        db.collection(itemsPath)
            .whereField("userId", isEqualTo: self.userId)
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.items = querySnapshot.documents.compactMap { document -> Item? in
                        try? document.data(as: Item.self)
                    }
                }
            }
    }
    
    func addItem(_ item: Item) {
        do {
            var userItem = item
            userItem.userId = self.userId
            let _ = try db.collection("items").addDocument(from: userItem)
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
