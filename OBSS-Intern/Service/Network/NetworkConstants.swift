//
//  ServiceConstants.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation

struct NetworkConstants{

    // define process env
    static let env = ProcessInfo.processInfo.environment
    
    // constants variables
    static let apiKey = env["ApiKey"] ?? ""
    static let scheme = env["BaseScheme"] ?? ""
    static let baseUrl = env["BaseUrl"] ?? ""
    static let chatBotBaseUrl = env["ChatBotBaseUrl"] ?? ""
    static let chatBotApiKey = env["ChatBotApiKey"] ?? ""
    static let serviceVersion = "/3"
    static let originalImagePath = "https://image.tmdb.org/t/p/original"
    static let w500ImagePath = "https://image.tmdb.org/t/p/w500"
    static let w200ImagePath = "https://image.tmdb.org/t/p/w200"
    
    static let chatBotPrompt = LocalizationKeys.ChatBot.chatBotPrompt
}
