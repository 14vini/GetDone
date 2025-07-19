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
    @State private var showAddView = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)

            VStack {
                StyleTitle
                    .padding()
                Divider()
                CardItems
            }

            VStack {
                Spacer()
                tabbarButtons
              
            }
        }
    }
}

extension ListView {
    
    private var tabbarButtons: some View{
        HStack {
            Spacer()
            
            ZStack {
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()// acao de feedback
                    showAddView.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.cyan.opacity(0.8))
                        .frame(width: 60, height: 60)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .offset(y: -20)
                .sheet(isPresented: $showAddView) {
                    AddView()
                        .presentationDetents([.medium, .large])
                        .presentationCornerRadius(40)
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 0)
        }
    }
    private var StyleTitle: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Sat")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("July 19")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.gray)
                    Text("2025")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal)
            
            HStack(alignment: .center){
                HStack(spacing: 5) {
                    ForEach(13...19, id: \.self) { day in
                        VStack {
                            Text(weekday(for: day))
                                .font(.headline)
                                .foregroundStyle(.gray)
                            Text("\(day)")
                                .font(.headline)
                                .foregroundColor(day == 19 ? .cyan : .gray)
                        }
                        .frame(width: 50, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(day == 19 ? Color.gray : Color.clear)
                                .shadow(radius: 3)
                        )
                     
                    }
                }
            }
        }
    }
    
    private var CardItems: some View {
        ZStack{
            if listViewModel.items.isEmpty {
                taskList
                Text("no items...")
                    .foregroundStyle(.primary.opacity(0.5))
            } else {
                VStack {
                    taskList
                }
            }
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
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
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
          
        }

}

// Função auxiliar para obter o nome do dia da semana
private func weekday(for day: Int) -> String {
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    return weekdays[(day - 13) % weekdays.count]
}
    
#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
}
