//
//  AddView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss // Forma mais moderna de obter o presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    
    // NOVO: Propriedade para receber a data selecionada da ListView
    let selectedDate: Date
    
    @State var textFieldText: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
    
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    
                    
                    Text("\(selectedDate.extractDate(format: "dd/MM"))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.secondary)
                    
                    textfieldStyle
                    
                } .padding()
            }
            
            // Add Button
            addButton
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    // Alerta
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    // add button : valida texto e salva ou mostra alerta
    func addButtonPressed() {
        if isAppropriateText() {
            listViewModel.addItem(title: textFieldText, date: selectedDate)
            dismiss()
        } else {
            alertTitle = "Você precisa digitar algo para adicionar uma nova tarefa"
            showAlert = true
        }
    }
    
    // Verifica se há texto suficiente
    func isAppropriateText() -> Bool {
        return textFieldText.count > 0
    }
}

// MARK: - Componentes da View
extension AddView{
    private var textfieldStyle: some View {
        TextField("Digite aqui...", text: $textFieldText)
            .font(.title.bold())
            .padding()
            .shadow(color: .white.opacity(0.2), radius: 2, x: 0, y: 0)

    }
    
    private var addButton: some View {
        Button(action: addButtonPressed) {
            Image(systemName: "checkmark")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.cyan.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .shadow(color: .primary.opacity(0.5), radius: 1, x: 0, y: 0)
        }
        .padding(20)
    }
}

#Preview {
    NavigationView {
        AddView(selectedDate: Date())
    }
    .environmentObject(ListViewModel())
}
