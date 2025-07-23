//
//  chatViewModel.swift
//  GetDone
//
//  Created by Vinicius on 7/21/25.
//



import Foundation

// O ViewModel precisa ser um ObservableObject para que a View possa "ouvi-lo".
class ChatViewModel: ObservableObject {
    
    // As variáveis de estado da View agora vivem aqui.
    // O @Published avisa a View sempre que um valor muda.
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isProcessing: Bool = false
    @Published var shouldDismiss: Bool = false // Para controlar o fecho da view
    
    // Injetamos as dependências que o ViewModel precisa para trabalhar.
    private let listViewModel: ListViewModel
    private let aiService = AIService()
    
    init(listViewModel: ListViewModel) {
        self.listViewModel = listViewModel
        setupInitialMessage()
    }
    
    private func setupInitialMessage() {
        // Mensagem de boas-vindas
        messages.append(ChatMessage(text: "Eai! Posso adicionar tarefas por você. Tente 'treino de peito e ombro para a próxima sexta-feira'.", role: .bot))
    }
    
    // A função de lógica principal, movida da View para cá.
    @MainActor // Garante que as atualizações de @Published aconteçam na thread principal
    func sendMessage() async {
        let userMessageText = inputText
        guard !userMessageText.isEmpty else { return }
        
        isProcessing = true
        inputText = ""
        
        messages.append(ChatMessage(text: userMessageText, role: .user))
        
        do {
            if let (title, date) = try await aiService.generateTask(from: userMessageText) {
                listViewModel.addItem(title: title.capitalized, date: date)
                
                let dateString = date.extractDate(format: "dd/MM/YYYY")
                let botResponse = "Agendado! \"\(title.capitalized)\" adicionado para \(dateString)."
                messages.append(ChatMessage(text: botResponse, role: .bot))
                
                // Avisa a View que ela deve ser fechada
                shouldDismiss = true
                
            } else {
                let botResponse = "Desculpe, não consegui processar esse pedido. Pode tentar reformular?"
                messages.append(ChatMessage(text: botResponse, role: .bot))
            }
        } catch {
            let botResponse = "Ocorreu um erro de comunicação. Por favor, tente novamente."
            messages.append(ChatMessage(text: botResponse, role: .bot))
        }
        
        isProcessing = false
    }
}
