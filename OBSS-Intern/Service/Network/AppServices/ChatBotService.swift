//
//  ChatBotService.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import Foundation

protocol ChatBotServiceProtocol {
    func sendMessage(message: String, completion: @escaping (Result<ChatBotModelResponse, NetworkError>) -> Void)
}

class ChatBotService: ChatBotServiceProtocol{
    func sendMessage(message: String, completion: @escaping (Result<ChatBotModelResponse, NetworkError>) -> Void) {
        guard let request = try? NetworkServiceRoutes.NetworkChatbotRoutes.getChatbotMessage(message: message).makeRequest() else{
            return completion(.failure(.invalidUrl))
        }
        NetworkManager.shared.request(request: request, completion: completion)
    }
}
