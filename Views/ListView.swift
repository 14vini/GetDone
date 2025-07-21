//
//  ListView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var showAddView = false
    @State private var selectedDate: Date = Date()
    
    // Isso mantém a view principal limpa e a lógica de filtro isolada.
    private var filteredItems: [ItemModel] {
        return listViewModel.items.filter { item in
            //função auxiliar para comparar apenas o dia, mês e ano.
            isSameDay(date1: item.date, date2: selectedDate)
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 10) {
                CalendarView(selectedDate: $selectedDate)
                Divider()
                CardItems
            }
            .padding(.top)
            
            VStack {
                Spacer()
                tabbarButtons
            }
            
        }
        .padding(.top)

    }
}

// MARK: - COMPONENTES DA VIEW
extension ListView {
    
    private var tabbarButtons: some View {
        HStack {
            Spacer()
            ZStack {
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    showAddView.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(width: 70, height: 70)
                        .background(.cyan)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                .blur(radius: 1)
                        )
                        .shadow(radius: 2)
                }
                .sheet(isPresented: $showAddView) {
                    // MODIFICADO: Passamos a data selecionada para a AddView.
                    // Lembre-se que sua AddView precisa estar preparada para receber essa data.
                    AddView(selectedDate: selectedDate)
                        .presentationDetents([.medium, .large])
                        .presentationCornerRadius(40)
                }
            }
            .padding()
        }
    }
    
    private var CardItems: some View {
        ZStack{
            // MODIFICADO: Verificamos se a lista FILTRADA está vazia.
            if filteredItems.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Text("Nenhuma tarefa para este dia.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Toque em '+' para adicionar uma.")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
            } else {
                // Se não estiver vazia, mostramos a lista de tarefas.
                taskList
            }
        }
        .shadow(color: .primary.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    private var taskList: some View {
        List {
            // MODIFICADO: O ForEach agora percorre a lista FILTRADA.
            ForEach(filteredItems) { item in
                ListRowView(item: item)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .onTapGesture {
                        withAnimation(.linear){
                            listViewModel.updateItem(item: item)
                        }
                    }
            }
            // MODIFICADO: Usar funções que entendem a lista filtrada.
            .onDelete(perform: deleteFilteredItem)
            .onMove(perform: moveFilteredItem)
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
    }
    
    // NOVO: Funções para deletar e mover itens da lista filtrada corretamente.
    // Elas "traduzem" os índices da lista filtrada para os índices da lista completa.
    
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


// MARK: - EXTENSÃO DE DATE
extension Date {
    func extractDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}

func isSameDay(date1: Date, date2: Date) -> Bool {
    return Calendar.current.isDate(date1, inSameDayAs: date2)
}


// O Preview permanece o mesmo
#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}
