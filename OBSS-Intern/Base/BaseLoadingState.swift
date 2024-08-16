//
//  BaseLoadingState.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 6.08.2024.
//

import Foundation

enum BaseLoadingState {
    case loading
    case loaded
    case error(Error)
}
