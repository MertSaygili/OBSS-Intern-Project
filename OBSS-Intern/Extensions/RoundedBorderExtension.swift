//
//  RoundedBorderExtension.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 15.08.2024.
//

import UIKit

typealias RoundedBorderExtension = UIView

extension RoundedBorderExtension {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
