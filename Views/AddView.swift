//
//  AddView.swift
//  GetDone
//
//  Created by Vinicius on 4/22/25.
//

import SwiftUI

struct AddView: View {
    
    @State var textFiledText: String = ""
    
    var body: some View {
        
        ScrollView{
            
            VStack{
                TextField("type here...", text: $textFiledText)
                    .padding(.horizontal)
                    .frame(height: 55 )
                    .background(Color(.systemGray6))
                    .cornerRadius(30)
            
                Button(action: {
                    
                }, label: {
                    Text("Add" .uppercased())
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(30)
            })
                    
            }
            .padding()
            
        }
        .navigationTitle("Add an new item")
        
    }
}

#Preview {
    NavigationView {
        AddView()
    }
}
