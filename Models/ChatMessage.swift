//
//  ChatMessage.swift
//  GetDone
//
//  Created by Vinicius on 7/21/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let role: MessageRole
}

enum MessageRole {
    case user
    case bot
}
