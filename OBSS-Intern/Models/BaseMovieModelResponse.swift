//
//  BaseResponseModel.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation

// MARK: - BaseResponseModel
struct BaseMovieModelResponse: Codable {
    let page: Int?
    let results: [MovieModel]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
