//
//  ToastServiceManager.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 15.08.2024.
//

import UIKit

class ToastServiceManager {
    static func showToast(message: String, duration: TimeInterval = 2.0, view: UIView, x: Double? = nil, y: Double? = nil, height: Double? = nil) {
        let theme = ThemeManager.shared.currentTheme
        let newX = x ?? Double(view.frame.size.width/2 - 150)
        let newY = y ?? Double(view.frame.size.height - 150)
        
        let toastLabel = UILabel()
        toastLabel.backgroundColor = theme == Theme.dark ? UIColor.white.withAlphaComponent(0.3) : UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let maxSize = CGSize(width: 300, height: CGFloat.greatestFiniteMagnitude)
        let expectedSize = toastLabel.sizeThatFits(maxSize)
        toastLabel.frame = CGRect(x: newX, y: newY, width: 300, height: max(expectedSize.height + 20, height ?? 35.0))
        
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

