//
//  ItemModel.swift
//  GetDone
//
//  Created by Vinicius on 4/23/25.
//

import Foundation

struct ItemModel: Identifiable {
    
    var id: String = UUID().uuidString
    var title: String
    var isDone: Bool = false
}
