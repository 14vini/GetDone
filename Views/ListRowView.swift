//
//  ListRowView.swift
//  GetDone
//
//  Created by Vinicius on 4/22/25.
//

import SwiftUI

struct ListRowView: View {
    
    let title: String
    
    var body: some View {
        HStack{
            Image(systemName: "checkmark.circle")
            Text(title)
            Spacer()
        }
    }
}


#Preview {
    ListRowView(title : "firts item of the list")
}
