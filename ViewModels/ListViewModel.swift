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
    
    // acao de feedback
    func feedbackHaptics(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
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
        feedbackHaptics()
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
        feedbackHaptics()
    }
    
    func addItem(title: String, date: Date) {
          let newItem = ItemModel(title: title, isDone: false, date: date)
          items.append(newItem)
          feedbackHaptics()
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
