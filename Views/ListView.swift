//
//  ListView.swift
//  GetDone
//
//  Created by Vinicius on 4/22/25.
//
import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        ZStack {
            // background Color
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // styling title
            VStack(spacing: 30) {
                HStack(spacing: 0) {
                    
                    Text("Today's tasks")
                        .font(.largeTitle)
                        .foregroundColor(.primary.opacity(0.85))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 1)
                .padding(.bottom, 0)

                // Card of items
                VStack {
                    taskList
                }
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            .padding()
        }
    }
    
    private var taskList: some View {
            List {
                ForEach(listViewModel.items) { item in
                    ListRowView(item: item)
                        .listRowBackground(Color.clear)
                }
                .onDelete(perform: listViewModel.deleteItem)
                .onMove(perform: listViewModel.moveItem)
            }
            .border(Color.white.opacity(0.05), width: 1)
            .scrollContentBackground(.hidden)
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: EditButton().foregroundColor(.accentColor),
                trailing: NavigationLink("Add", destination: AddView()).foregroundColor(.accentColor)
            )
        }
}

#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}
