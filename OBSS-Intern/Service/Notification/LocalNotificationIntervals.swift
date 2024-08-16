//
//  LocalNotificationIntervals.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 14.08.2024.
//

import Foundation

enum LocalNotificationIntervals {
    case thirtyMinute
    case oneHour
    case oneDay
    case threeDays
    case week

    var timeInterval: TimeInterval {
        switch self {
        case .thirtyMinute: return 10
        case .oneHour: return 60 * 60
        case .oneDay: return 24 * 60 * 60
        case .threeDays: return 40
        case .week: return 60 * 60 * 24 * 7
        }
    }
    
    var getIdentifer: String {
        switch self {
        case .thirtyMinute: return "thirtyMinute"
        case .oneHour: return "oneHour"
        case .oneDay: return "oneDay"
        case .threeDays: return "threeDays"
        case .week: return "week"
        }
    }
}
