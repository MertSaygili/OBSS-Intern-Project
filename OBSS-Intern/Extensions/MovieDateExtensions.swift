//
//  MoiveDateExtensions.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 1.08.2024.
//

import Foundation

typealias MovieDateExtension = Date
typealias MovieDateString = String

extension MovieDateExtension{
    var getDateTimeOfMinus2Day: String{
        guard let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: self) else {return "2024-07-31"}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: twoDaysAgo)
    }
}

extension MovieDateString{
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let currentLocale = LocalizationManager.shared.getCurrentLanguage()?.rawValue ?? "en-US"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: currentLocale.replacingOccurrences(of: "-", with: "_"))
        return dateFormatter.date(from: self)
    }

    func toFormattedDateString() -> String? {
        guard let date = self.toDate() else { return nil }
        let currentLocale = LocalizationManager.shared.getCurrentLanguage()?.rawValue ?? "en-US"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: currentLocale.replacingOccurrences(of: "-", with: "_"))

        return dateFormatter.string(from: date)
    }
}
