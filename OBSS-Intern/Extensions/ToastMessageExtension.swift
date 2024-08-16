//
//  ToastMessageExtension.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 8.08.2024.
//

import UIKit

typealias ToastMessageExtension = UIViewController

extension ToastMessageExtension {
    func showToast(message: String, duration: TimeInterval = 2.0, x: Double? = nil, y: Double? = nil, height: Double? = nil) {
        ToastServiceManager.showToast(message: message, duration: duration, view: self.view, x: x, y: y, height: height)
    }
}
