//
//  AddView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//

import SwiftUI


struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    @State var textFiledText: String = ""
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    //title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Add a new task")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary.opacity(0.9))
                    }
                    .padding(.top)
                    
                    // TextField styles
                    TextField("Type here...", text: $textFiledText)
                        .padding()
                        .frame(height: 60)
                        .background(
                            Color.primary.opacity(0.05)
                            .background(.ultraThinMaterial)
                            .blur(radius: 1.5)
                        )
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1))
                        .foregroundColor(.primary)
                    
                    //button SAVE styles
                    Button(action:
                            saveButtonPressed, label: {
                        Text("save".uppercased())
                            .foregroundColor(.secondary)
                            .font(.headline)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(
                                Color.cyan.opacity(0.8)
                                    .background(.ultraThinMaterial)
                                    .blur(radius: 1.5)
                                    )
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                            )
                    })
            }
            .padding()
            }
            
          
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    func saveButtonPressed() {
        listViewModel.addItem(title: textFiledText)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        AddView()
    }.environmentObject(ListViewModel())
}
