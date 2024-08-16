//
//  BasePersonMovieModelResponse.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 6.08.2024.
//

import Foundation

struct BasePersonMovieModelResponse: Codable{
    let id: Int?
    let cast: [MovieDetailModel]?
    let crew: [MovieDetailModel]?
}
