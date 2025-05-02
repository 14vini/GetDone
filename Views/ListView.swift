//
//  ListView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//i
import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // background
            Image(colorScheme == .dark ? "backgroundImageDark" : "backgroundImageLight")
                      .resizable()
                      .ignoresSafeArea()
                      .blur(radius: 1)
            
         
            
            // styling title
            VStack(spacing: 30) {
                HStack(spacing: 0) {
                    
                    Text("Today's tasks")
                        .font(.largeTitle.bold())
                        .foregroundColor(colorScheme == .dark ? .white : .black )
                            .opacity(0.7)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 1)

                // Card of items
                ZStack{
                    if listViewModel.items.isEmpty {
                        taskList
                        Text("no items...")
                            .foregroundColor(.primary.opacity(0.5))
                        
                    } else {
                        VStack {
                            taskList
                        }
                    }
                }
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .navigationBarItems(
                    leading: EditButton()
                        .foregroundColor(.accentColor),
                        
                    trailing: NavigationLink("Add", destination: AddView())
                        .navigationViewStyle(.stack)
                        .foregroundColor(.accentColor)
                            )
            }
            .padding()
        }
    }
    
    private var taskList: some View {
            List {
                ForEach(listViewModel.items) { item in
                    ListRowView(item: item)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            withAnimation(.linear){
                                listViewModel.updateItem(item: item)
                            }
                        }
                }
                .onDelete(perform: listViewModel.deleteItem)
                .onMove(perform: listViewModel.moveItem)
            }// stylining card
            .border(Color.primary.opacity(0.1), width: 1)
            .scrollContentBackground(.hidden)
            .background(Color(colorScheme == .dark ? .black : .white).opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                .stroke(Color.primary.opacity(0.1), lineWidth: 3))
        }
}

#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}
