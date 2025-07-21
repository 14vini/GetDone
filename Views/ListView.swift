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
    
    // NOVO: Variável de estado para guardar a data que o usuário selecionou.
    // Inicia com a data atual.
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 10) {
                // MODIFICADO: Substituímos o StyleTitle antigo pela nova CalendarView.
                // Passamos a data selecionada usando um "binding" ($).
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
                        .shadow(radius: 2)
                }
                .sheet(isPresented: $showAddView) {
                    AddView()
                        .presentationDetents([.medium, .large])
                        .presentationCornerRadius(50)
                }
            }
            .padding()
        }
    }
    
    private var CardItems: some View {
        // A lógica desta View permanece a mesma por enquanto.
        // No futuro, podemos filtrar os itens baseados na 'selectedDate'.
        ZStack{
            if listViewModel.items.isEmpty {
                taskList
                Text("Nenhuma tarefa adicionada.")
                    .foregroundStyle(.primary.opacity(0.5))
            } else {
                VStack {
                    taskList
                }
            }
        }
        .shadow(color: .primary.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    private var taskList: some View {
        List {
            ForEach(listViewModel.items) { item in
                ListRowView(item: item)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .onTapGesture {
                        withAnimation(.linear){
                            listViewModel.updateItem(item: item)
                        }
                    }
            }
            .onDelete(perform: listViewModel.deleteItem)
            .onMove(perform: listViewModel.moveItem)
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - EXTENSÃO DE DATE
// NOVO: Funções úteis para trabalhar com datas. Isso deixa o código mais limpo.
extension Date {
    
    /// Converte uma data para um formato de texto específico.
    /// Ex: "dd" -> "21", "EEEE" -> "Monday"
    func extractDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        // Garante que o calendário do usuário seja respeitado
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    /// Verifica se a data é hoje.
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}

/// Função auxiliar global para comparar se duas datas são o mesmo dia (ignorando a hora).
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
