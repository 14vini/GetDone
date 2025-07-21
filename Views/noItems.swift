//
//  NoItemsView.swift
//  GetDone
//
//  Created by Vinicius on 5/2/25.
//

import SwiftUI

struct NoItemsView: View {
    
    @State var animate: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    // NOVO: A view precisa saber qual é a data selecionada para
    // poder passá-la para a AddView quando o botão for clicado.
    let selectedDate: Date
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("Nenhuma tarefa para este dia...")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 15)
                
                // MODIFICADO: O destino agora usa a propriedade 'selectedDate'
                NavigationLink(
                    destination: AddView(selectedDate: selectedDate),
                    label: {
                        Text("Adicionar Tarefa")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            // MODIFICADO: A forma de aplicar múltiplos fundos foi corrigida.
                            // Usamos um ZStack dentro do .background para sobrepor o material e a cor.
                            .background(
                                ZStack {
                                    // Efeito de vidro
                                    Capsule().fill(.ultraThinMaterial)
                                    // Cor semi-transparente por cima
                                    Capsule().fill(Color.cyan.opacity(0.8))
                                }
                            )
                    })
                .padding(.horizontal, animate ? 15 : 20)
                .shadow(
                    color: animate ? Color.cyan.opacity(0.9) : Color.cyan.opacity(0.4),
                    radius: animate ? 20 : 10,
                    x: 0,
                    y: animate ? 10 : 5)
                .scaleEffect(animate ? 1.05 : 1.0)
                .offset(y: animate ? -5 : 0)
            }
            .frame(maxWidth: 400)
            .multilineTextAlignment(.center)
            .padding(40)
            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 1.5)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
    
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // MODIFICADO: O preview precisa de uma data de exemplo para funcionar.
            NoItemsView(selectedDate: Date())
                .navigationTitle("Title")
        }
    }
}
