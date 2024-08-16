//
//  MovieDurationExtension.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 2.08.2024.
//

import Foundation

typealias MovieDurationExtension = Int

extension MovieDurationExtension{
    func toHoursAndMinutes() -> String {
        let hours = self / 60
        let minutes = self % 60

        if hours > 0 {
            return "\(hours) \(LocalizationKeys.Common.hourShort.localize()) \(minutes) \(LocalizationKeys.Common.minuteShort.localize())"
        } else {
            return "\(minutes) \(LocalizationKeys.Common.minuteShort.localize())"
        }
    }
}
