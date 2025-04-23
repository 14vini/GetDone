//
//  ListView.swift
//  GetDone
//
//  Created by Vinicius on 4/22/25.
//

import SwiftUI

struct ListView: View {
    @State var items: [String] = [
        "this is the firta item",
        "second",
        "third"
    ]
    
    var body: some View {
        List{
            ForEach (items, id: \.self) { item in
                ListRowView(title: item)
            }
            
        }
        .listStyle(PlainListStyle())
        .navigationTitle("GetDone")
        .navigationBarItems(
            leading: EditButton(),
            trailing:
                NavigationLink("Add", destination: AddView())
        )
    }
}

#Preview {
    NavigationView{
        ListView()
    }
}

