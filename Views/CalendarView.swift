//
//  CalendarView.swift
//  GetDone
//
//  Created by Vinicius on 7/21/25.
//

import SwiftUI

// MARK: - CALENDAR VIEW
// NOVO: A view que criamos para o calendário semanal
struct CalendarView: View {
    @Binding var selectedDate: Date
    @State private var week: [Date] = []
    
    // Guarda o primeiro dia da semana atual para calcular a navegação
    @State private var currentWeekFirstDay: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Cabeçalho que mostra a data selecionada
            headerView
            
            // A fileira com os dias da semana
            weekDaysView
            
        }
        .padding(.horizontal)
        .onAppear(perform: fetchWeek) // Carrega a semana atual quando a view aparece
    }
    
    // View do Cabeçalho
    @ViewBuilder
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                // Dia da semana
                Text(selectedDate.extractDate(format: "EEEE"))
                    .font(.system(size: 40, weight: .bold))
                    .fontDesign(.rounded)
                    .foregroundStyle(.primary)
                
                
                HStack(spacing: 5) {
                    // Mês e Dia
                    Text(selectedDate.extractDate(format: "MMMM dd"))
                        .font(.system(size: 24, weight: .semibold))
                        .fontDesign(.rounded)
                    // Ano (ex: 2025)
                    Text(selectedDate.extractDate(format: "YYYY"))
                        .font(.system(size: 24, weight: .semibold))
                        .fontDesign(.rounded)
                }
                .foregroundStyle(.gray)
            }
            
            Spacer()
            
            // Botões para navegar entre as semanas
            HStack(spacing: 20) {
                Button(action: goToPreviousWeek) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                Button(action: goToNextWeek) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(8)
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    // View da fileira de dias
    @ViewBuilder
    private var weekDaysView: some View {
        HStack(spacing: 5) {
            ForEach(week, id: \.self) { day in
                VStack(spacing: 8) {
                    // Nome do dia da semana (ex: M)
                    Text(day.extractDate(format: "E").prefix(1))
                        .font(.headline)
                        .foregroundStyle(isSameDay(date1: day, date2: selectedDate) ? .white : .gray)

                    // Número do dia
                    Text(day.extractDate(format: "dd"))
                        .font(.headline)
                        .foregroundStyle(isSameDay(date1: day, date2: selectedDate) ? .white : .primary)
                }
                .frame(width: 45, height: 70)
                .background(
                    // Lógica para destacar o dia selecionado
                    ZStack {
                        if isSameDay(date1: day, date2: selectedDate) {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.cyan)
                                .shadow(radius: 3)
                        } else if day.isToday() {
                             RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.red, lineWidth: 1)
                        }
                    }
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedDate = day
                    }
                }
            }
        }
    }
    
    // MARK: Funções de Lógica do Calendário
    
    /// Carrega a semana inteira baseada no `currentWeekFirstDay`
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
    
    /// Navega para a semana anterior
    func goToPreviousWeek() {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeekFirstDay) {
            currentWeekFirstDay = newDate
            selectedDate = newDate // Seleciona o primeiro dia da nova semana
            fetchWeek()
        }
    }
    
    /// Navega para a próxima semana
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
