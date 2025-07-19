//
//  ListViewModel.swift
//  GetDone
//
//  Created by Kauã Vinicius on 5/2/25.
//

import Foundation
import SwiftUI

/*
 CRUD FUNCTIONS:
 
 Create
 Read
 Update
 Delete
 */

class ListViewModel: ObservableObject {
    
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    
    let itemsKey: String = "items_list"
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }

        self.items = savedItems
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()// acao de feedback
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()// acao de feedback
    }
    
    func addItem(title: String) {
        let newItem = ItemModel(title: title, isDone: false)
        items.append(newItem)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()// acao de feedback
    }
    
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateComptetion()
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
}
