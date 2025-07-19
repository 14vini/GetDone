//
//  ListRowView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//

import SwiftUI

struct ListRowView: View {
    @State
    var item: ItemModel
    
    var body: some View {
        HStack{
            
            Image(systemName: item.isDone
                  ? "largecircle.fill.circle"
                  : "circle")
            .imageScale(.large)
            .foregroundColor(.cyan)
          
            Text(item.title)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(10)
            Spacer()
            
            
        }
    }
}
    

#Preview {
    let item1 = ItemModel(title: "First Item", isDone: true)
    let item2 = ItemModel(title: "Second Item", isDone: false)

    return Group {
        ListRowView(item: item1)
        ListRowView(item: item2)
    }
    
    
}
