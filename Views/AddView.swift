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
            Image (colorScheme == .dark ? "backgroundImageDark": "backgroundImageLight")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 2)
      
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    //title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Add a new task")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary.opacity(0.9))
                            
                    }
                    .padding(.top)
                    
                    // TextField styles
                    TextField("Type here...", text: $textFieldText)
                        .padding()
                        .frame(height: 60)
                        .border(Color.primary.opacity(0.1), width: 1)
                        .background(Color(colorScheme == .dark ? .black : .white).opacity(0.4))
                    
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 2))
                        .foregroundColor(.primary)
                    
                    //button SAVE styles
                    Button(action:
                            saveButtonPressed, label: {
                        Text("save".uppercased())
                            .foregroundColor(.secondary)
                            .font(.headline)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(
                                Color.cyan.opacity(0.7)
                                    .background(.ultraThinMaterial)
                                    .blur(radius: 1)
                                    )
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.primary.opacity(0.2), lineWidth: 3)
                            )
                    })
            }
            .padding()
            }
            .background(Color.black.opacity(0.001))
          
        }
        .navigationBarTitle("", displayMode: .inline)
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func getAlert() -> Alert{
        return Alert(title: Text(alertTitle))
    }
    
    func saveButtonPressed() {
        if isAppropriateText(){
            alertTitle = "You need to type something to add a new task 😉"
            listViewModel.addItem(title: textFieldText)
            presentationMode.wrappedValue.dismiss() // use this to close the "page" after you add a new task
        }
    }
    
    func isAppropriateText() -> Bool  {
        if textFieldText.count < 1{
            return false
        }
        return true
    }}

#Preview {
    NavigationView {
        AddView()
    }.environmentObject(ListViewModel())
}
