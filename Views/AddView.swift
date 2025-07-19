//
//  AddView.swift
//  GetDone
//
//  Created by Kauã Vinicius on 4/22/25.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var textFieldText: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
       
            
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
      
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
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
    
    // Alerta padrão
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    // Botão de salvar: valida texto e salva ou mostra alerta
    func saveButtonPressed() {
        if isAppropriateText() {
            listViewModel.addItem(title: textFieldText)
            presentationMode.wrappedValue.dismiss()
        } else {
            alertTitle = "You need to type something to add a new task"
            showAlert = true
        }
    }
    
    // Verifica se há texto suficiente
    func isAppropriateText() -> Bool {
        return textFieldText.count > 0
    }
}

extension AddView{
    private var textfieldStyle: some View {
        TextField("Type here...", text: $textFieldText)
            .font(.title.bold())
            .padding()
            .shadow(color: .white.opacity(0.2), radius: 2, x: 0, y: 0)

    }
    
    private var addButton: some View {
        Button(action: saveButtonPressed) {
            Image(systemName: "checkmark")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.cyan.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .primary.opacity(0.5), radius: 2, x: 0, y: 0)
        }
        .padding(20)
    }
}

// Preview
#Preview {
    NavigationView {
        AddView()
    }
    .environmentObject(ListViewModel())
}
