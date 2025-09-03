//
//  CalendarView.swift
//  GetDone
//
//  Created by Vinicius on 7/21/25.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Binding var selectedDate: Date
    @State private var week: [Date] = []
    
    // Guarda o primeiro dia da semana atual para calcular a navegação
    @State private var currentWeekFirstDay: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            // Cabeçalho que mostra a data selecionada
            headerView
            
            // A fileira com os dias da semana
            weekDaysView
            Divider()

        }
        .padding()
        .onAppear(perform: fetchWeek) // Carrega a semana atual quando a view aparece
    }
    
    // View do Cabeçalho
    @ViewBuilder
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                // Dia da semana
                Text(selectedDate.extractDate(format: "EEE"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.primary)
                    .textCase(.uppercase)
                
                
                HStack(spacing: 5) {
                    // Mês e Dia
                    Text(selectedDate.extractDate(format: "MMMM dd"))
                     
                    // Ano (ex: 2025)
                    Text(selectedDate.extractDate(format: "YYYY"))
                        
                }
                .foregroundStyle(.gray)
                .font(.title2)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
            }
            
            Spacer()
            
            // Botões para navegar entre as semanas
            HStack(spacing: 20) {
                Button(action: {
                    listViewModel.feedbackHaptics()
                    goToPreviousWeek()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Button(action: {
                    listViewModel.feedbackHaptics()
                    goToNextWeek()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(10)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .glass()
           
        }
    }
    
    // View da fileira de dias
    @ViewBuilder
    private var weekDaysView: some View {
        HStack(spacing: 8) {
            ForEach(week, id: \.self) { day in
                VStack(spacing: nil) {
                    
                    // Nome do dia da semana
                    Text(day.extractDate(format: "E").prefix(1))
                        .font(.headline)
                        .foregroundStyle(isSameDay(date1: day, date2: selectedDate) ? Color.primary : .gray)

                    // Número do dia
                    Text(day.extractDate(format: "dd"))
                        .font(.headline)
                        .foregroundStyle(isSameDay(date1: day, date2: selectedDate) ? Color.primary : .primary)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(
                    // selected day style
                    ZStack {
                        if isSameDay(date1: day, date2: selectedDate) {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.cyan.opacity(0.8))
                               
                        } else if day.isToday() {
                             RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.cyan, lineWidth: 2)
                        }
                    }
                    .glass()
                )
                .onTapGesture {
                    listViewModel.feedbackHaptics()
                    withAnimation(.interactiveSpring) {
                        selectedDate = day
                    }
                    
                }
            }
        }
    }
    
    // MARK: Funções de Lógica do Calendário
    // cllocar essas funções na view model 
    // Carrega a semana inteira 
    func fetchWeek() {
        let calendar = Calendar.current
        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: currentWeekFirstDay)
        
        guard let firstDay = weekInterval?.start else { return }
        
        var weekDays: [Date] = []
        (0..<7).forEach { dayOffset in
            if let day = calendar.date(byAdding: .day, value: dayOffset, to: firstDay) {
                weekDays.append(day)
            }
        }
        self.week = weekDays
    }
    
    //Navega para a semana anterior
    func goToPreviousWeek() {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeekFirstDay) {
            currentWeekFirstDay = newDate
            selectedDate = newDate // Seleciona o primeiro dia da nova semana
            fetchWeek()
        }
    }
    
    //Navega para a próxima semana
    func goToNextWeek() {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekFirstDay) {
            currentWeekFirstDay = newDate
            selectedDate = newDate // Seleciona o primeiro dia da nova semana
            fetchWeek()
        }
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> Content

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}


#Preview {
    StatefulPreviewWrapper(Date()) { date in
        CalendarView(selectedDate: date)
    }
}
