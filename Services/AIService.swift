//
//  AIService.swift
//  GetDone
//
//  Created by Vinicius on 7/21/25.
//

import Foundation
import GoogleGenerativeAI

struct TaskResponse: Codable {
    let tarefa: String
    let data: String
}

class AIService {
    
    private let apiKey = "AIzaSyCzf2O3P7tPuxwv6rpUd_UHazi6AGomuNU" 
    
    func generateTask(from text: String) async throws -> (title: String, date: Date)? {
        
        // 1. A configuração para a resposta em JSON.
        let config = GenerationConfig(
            responseMIMEType: "application/json"
        )
        
        // 2. O modelo é criado AQUI com a configuração.
        let model = GenerativeModel(
            name: "gemini-2.5-flash",
            apiKey: apiKey,
            generationConfig: config
        )
        
        let prompt = """
             Você é um assistente de agendamento de treinos, amigável e conversador, para um aplicativo de lista de tarefas.
             A data de hoje é: \(Date().extractDate(format: "yyyy-MM-dd")).

             Sua tarefa é analisar o texto do usuário e determinar a intenção dele. Existem duas intenções possíveis: "task_creation" ou "conversational".

             1. Se a intenção for CRIAR UMA TAREFA (ex: "adicione um treino de perna para amanhã", "agende cardio para sexta"), retorne um JSON com a seguinte estrutura:
             {
               "response_type": "task_creation",
               "tarefa": "nome da tarefa extraído",
               "data": "YYYY-MM-DD"
             }

             2. Se a intenção for uma CONVERSA NORMAL (ex: "olá", "obrigado", "como você está?", "que dia é hoje?"), responda de forma amigável, natural e infomal se o usuraio falar informal. Nesse caso, retorne um JSON com a seguinte estrutura:
             {
               "response_type": "conversational",
               "message": "sua resposta amigável aqui"
             }

             Responda SEMPRE em formato JSON, sem nenhum texto adicional.

             Texto do usuário: "\(text)"
             """
        
        // 3. A chamada para gerar conteúdo agora usa apenas o prompt.
        let response = try await model.generateContent(prompt)
        
        guard let textResponse = response.text else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let data = textResponse.data(using: .utf8) else {
            return nil
        }
        
        guard let taskResponse = try? decoder.decode(TaskResponse.self, from: data) else {
            print("Erro: A resposta da IA não corresponde ao formato JSON esperado. Resposta recebida: \(textResponse)")
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: taskResponse.data) else {
            return nil
        }
        
        return (title: taskResponse.tarefa, date: date)
    }
}
