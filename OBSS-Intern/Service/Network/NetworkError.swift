//
//  ServiceError.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case requestFailed(statusCode: Int)
    case invalidResponse
    case dataConversionFailure
    case error
    case noData
    case decodingError(decodingError: Error)
    
    var message: String {
        switch self {
        case .invalidUrl:
            return LocalizationKeys.Error.invalidUrl.localize()
        case .requestFailed(let statusCode):
            return "\(LocalizationKeys.Error.requestFailed.localize()) \(statusCode)"
        case .invalidResponse:
            return LocalizationKeys.Error.invalidResponse.localize()
        case .dataConversionFailure:
            return LocalizationKeys.Error.dataConversionFailed.localize()
        case .error:
            return LocalizationKeys.Error.unkownError.localize()
        case .noData:
            return LocalizationKeys.Error.noDataFound.localize()        case .decodingError:
            return LocalizationKeys.Error.decodingError.localize()
        }
    }
}
