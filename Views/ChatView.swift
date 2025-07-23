//
//  ChatView.swift
//  GetDone
//
//  Created by Vinicius on 7/21/25.
//

import SwiftUI
// AIzaSyCzf2O3P7tPuxwv6rpUd_UHazi6AGomuNU
struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ChatViewModel
    
    init(listViewModel: ListViewModel) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(listViewModel: listViewModel))
    }
    
    var body: some View {
        VStack {
            Text("Chat")
                .font(.title2).bold()
                .padding()

            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                        }
                        if viewModel.isProcessing {
                           MessageBubble(message: ChatMessage(text: "Processando...", role: .bot))
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: viewModel.messages.count) {
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Digite aqui", text: $viewModel.inputText, axis: .vertical)
                    .padding(12)
                    .glass( shadowRadius: 1)
                
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    
                    Task {
                        await viewModel.sendMessage()
                    }
                }) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .background(.cyan.opacity(0.8))
                        .glass()
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isProcessing)
            }
            .padding()
        }
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            }
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            
            Text(message.text)
                .padding(12)
                .background(message.role == .user ? Color.cyan.opacity(0.8) : Color(uiColor: .systemGray5))
                .foregroundColor(message.role == .user ? .white : .primary)
                .cornerRadius(20)
            
            if message.role == .bot {
                Spacer()
            }
        }
    }
}

#Preview {
    ChatView(listViewModel: ListViewModel())
}
