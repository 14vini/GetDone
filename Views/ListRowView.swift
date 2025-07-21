//
//  ListRowView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//

import SwiftUI

struct ListRowView: View {
    
    let item: ItemModel
    
    var body: some View {
        HStack{
            Image(systemName: item.isDone
                  ? "checkmark.circle.fill"
                  : "circle")
            .imageScale(.large)
            .foregroundStyle(.cyan)
            .padding(.leading)
            
            Text(item.title)
                .fontWeight(.semibold)
                // line above the text if it's done
                .strikethrough(item.isDone, color: .primary.opacity(0.7))
                .foregroundStyle(item.isDone ? .secondary : .primary)
                .padding(15)
            Spacer()
        }
        .padding(5)
    }
}
    
#Preview {
   
    let item1 = ItemModel(title: "First Item", isDone: true, date: Date())
    let item2 = ItemModel(title: "Second Item", isDone: false, date: Date())

    return Group {
        ListRowView(item: item1)
        ListRowView(item: item2)
    }.padding(5)
}
