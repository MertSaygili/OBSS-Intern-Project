//
//  ChatbotRoutes.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import Foundation

extension NetworkServiceRoutes.NetworkChatbotRoutes: URLRequestConvertible {
    func makeRequest() throws -> URLRequest {
        let baseRequest = try makeAIRequest(path: path)
        
        if baseRequest.url == nil {
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: baseRequest.url!)
        request.httpMethod = method
        request.setValue("Bearer \(NetworkConstants.chatBotApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        switch self {
        case .getChatbotMessage(let message):
           let body: [String: Any] = [
               "model": "gpt-3.5-turbo",
               "messages": [
                   ["role": "user", "content": "\(NetworkConstants.chatBotPrompt.localize()) + \(message)"]
               ],
               "temperature": 0.7
           ]
           request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
               
        return request
    }
    
    private var path: String {
        switch self {
        case .getChatbotMessage:
            return "/v1/chat/completions"
        }
    }
    
    private var method: String {
        switch self {
        case .getChatbotMessage:
            return NetworkMethods.POST.rawValue
        }
    }
}
    
    
