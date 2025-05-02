//
//  ItemModel.swift
//  GetDone
//
//  Created by Vinicius on 4/23/25.
//

import Foundation

// imutable Struct
struct ItemModel: Identifiable, Codable {
    
    var id: String
    var title: String
    var isDone: Bool = false
    
    init(id: String = UUID().uuidString , title: String, isDone: Bool){
        self.id = UUID().uuidString
        self.title = title
        self.isDone = isDone
    }
    
    func updateComptetion() -> ItemModel {
        return ItemModel(id: id, title: title, isDone: !isDone)
    }
}
