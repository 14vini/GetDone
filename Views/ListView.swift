//
//  ListView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//
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

            VStack{
            // styling title
            StyleTitle
            CardItems
               
            }
            .padding()
        }
    }
    
}

extension ListView {
    private var StyleTitle: some View{
        VStack(spacing: 30) {
            HStack(spacing: 0) {
                
                Text("Today's tasks")
                    .font(.largeTitle.bold())
                    .foregroundColor(colorScheme == .dark ? .white : .black )
                    .opacity(0.7)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 1)
        }
    }
    
    private var CardItems: some View {
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
                .foregroundColor(.primary),
                
            trailing: NavigationLink("Add", destination: AddView())
                .navigationViewStyle(.stack)
                .foregroundColor(.primary)
                    )
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
            .scrollContentBackground(.hidden)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 0.5).blur(radius: 1))
        }

}
    
#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}
