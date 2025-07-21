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
            .foregroundStyle(.cyan)
            .padding(.leading)
          
            Text(item.title)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(15)
            Spacer()
            
            
        }
        .padding(5)
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
    

#Preview {
    let item1 = ItemModel(title: "First Item", isDone: true)
    let item2 = ItemModel(title: "Second Item", isDone: false)

    return Group {
        ListRowView(item: item1)
        ListRowView(item: item2)
    }.padding(5)
    
    
}
