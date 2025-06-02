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
            Image(colorScheme == .dark ? "backgroundImageDark" : "backgroundImageLight")
                 .resizable()
                 .ignoresSafeArea()
                 .blur(radius: 1)
            
//            Color(.systemGroupedBackground)
//                .ignoresSafeArea()
      
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    titleStyle
                    textfieldStyle
                    
                } .padding()
               
            }
            .background(Color.black.opacity(0.001)) // evita toque fantasma

            // Botão flutuante redondo
            Button(action: saveButtonPressed) {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 90, height: 90)
                    .background(Color.cyan.opacity(0.7))
                    .clipShape(Circle())
                    .shadow(color: .white.opacity(0.5), radius: 6, x: 0, y: 0)
            }
            .padding(20)
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
            alertTitle = "You need to type something to add a new task 😉"
            showAlert = true
        }
    }
    
    // Verifica se há texto suficiente
    func isAppropriateText() -> Bool {
        return textFieldText.count > 0
    }
}

extension AddView{
    private var titleStyle: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Add a new task")
                .font(.largeTitle.bold())
                .foregroundColor(.primary.opacity(0.8))
        }.padding(.top)

    }
    
    private var textfieldStyle: some View {
        TextField("Type here...", text: $textFieldText)
            .padding()
            .frame(height: 60)
            .background(.thinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 0.5)
                    .blur(radius: 1)
            )
            .foregroundColor(.primary)
            .shadow(color: .white.opacity(0.2), radius: 2, x: 0, y: 0)

    }
}

// Preview
#Preview {
    NavigationView {
        AddView()
    }
    .environmentObject(ListViewModel())
}
