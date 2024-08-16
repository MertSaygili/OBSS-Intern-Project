//
//  BaseCreditModelResponse.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation

struct BaseCreditModelResponse: Codable{
    let id: Int?
    let cast, crew: [CreditModel]?
}
