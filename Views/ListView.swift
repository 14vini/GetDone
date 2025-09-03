//
//  ListView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//

//task otimizar variaveis

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var showAddView = false
    @State private var showChatView = false
    @State private var selectedDate: Date = Date()
    
    private var filteredItems: [ItemModel] {
        return listViewModel.items.filter { item in
            isSameDay(date1: item.date, date2: selectedDate)
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
            VStack(spacing: nil) {
                
                // Calendar View
                CalendarView(selectedDate: $selectedDate)
                // list of items added
                CardItems
            }
            
            VStack {
                Spacer()
                // float buttons (change the name)
                tabbarButtons
            }
        }
        .padding(.top)
    }
}

// MARK: - Componentes da View
extension ListView {
    
    private var tabbarButtons: some View {
        HStack(alignment: .center) {
            Button(action: {
                listViewModel.feedbackHaptics()
                showChatView.toggle()
            }) {
                Image(systemName: "sparkles")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .background(.cyan.opacity(0.7))
                    .glass()

            }
            .sheet(isPresented: $showChatView) {
                ChatView(listViewModel: listViewModel)
                    .presentationDetents([ .large ])
                    .presentationCornerRadius(40)
            }
            
            Spacer()
            
            Button(action: {
                listViewModel.feedbackHaptics()
                showAddView.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .background(.cyan.opacity(0.7))
                    .glass()

            }
            .sheet(isPresented: $showAddView) {
                AddView(selectedDate: selectedDate)
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(40)
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    private var CardItems: some View {
        if filteredItems.isEmpty {
            VStack(spacing: 10) {
                Spacer()
                Text("Nenhuma tarefa para este dia.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text("Toque em '+' ou no assistente para adicionar uma.")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            taskList
        }
    }
    
    private var taskList: some View {
        List {
            ForEach(filteredItems) { item in
                ListRowView(item: item)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .onTapGesture {
                        withAnimation(.linear){
                            listViewModel.updateItem(item: item)
                        }
                    }
            }
            .onDelete(perform: deleteFilteredItem)
            .onMove(perform: moveFilteredItem)
            .listRowSeparator(.automatic)
        }
        .scrollContentBackground(.hidden)
        .padding(-25)
    }
    //colocar na viewModel
    func deleteFilteredItem(indexSet: IndexSet) {
        let idsToDelete = indexSet.map { filteredItems[$0].id }
        listViewModel.items.removeAll { item in
            idsToDelete.contains(item.id)
        }
    }
    
    func moveFilteredItem(from source: IndexSet, to destination: Int) {
        var originalSource = IndexSet()
        for index in source {
            let itemToMove = filteredItems[index]
            if let originalIndex = listViewModel.items.firstIndex(where: { $0.id == itemToMove.id }) {
                originalSource.insert(originalIndex)
            }
        }
        
        var originalDestination = 0
        if destination < filteredItems.count {
            let itemAtDestination = filteredItems[destination]
            if let originalIndex = listViewModel.items.firstIndex(where: { $0.id == itemAtDestination.id }) {
                originalDestination = originalIndex
            }
        } else {
            originalDestination = listViewModel.items.endIndex
        }

        listViewModel.items.move(fromOffsets: originalSource, toOffset: originalDestination)
    }
}

// MARK: - Extensões e Funções Auxiliares
extension Date {
    func extractDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: self)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}

func isSameDay(date1: Date, date2: Date) -> Bool {
    return Calendar.current.isDate(date1, inSameDayAs: date2)
}

// MARK: - Preview
#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}
