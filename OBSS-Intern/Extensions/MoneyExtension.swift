//
//  MoneyExtension.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 2.08.2024.
//

import Foundation

typealias MoneyExtension = Int

extension MoneyExtension{
    func moneyConverter() -> String? {
       let million = 1_000_000
       let thousand = 1_000

       if self >= million {
           return String(format: "%.1fM", Double(self) / Double(million))
       } else if self >= thousand {
           return String(format: "%.1fK", Double(self) / Double(thousand))
       } else {
           return String(self)
       }
    }
}
