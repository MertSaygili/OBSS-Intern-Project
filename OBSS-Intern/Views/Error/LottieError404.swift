//
//  404LottieError.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 7.08.2024.
//

import UIKit
import Lottie

class LottieError404: UIView {
    private var animationView: LottieAnimationView!
    
    // MARK: -- required functions
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public var lottiePath: String = AppImageConstants.kLottie404

    // MARK: --public functions
    func playAnimation() {
        animationView.play()
    }
    
    func stopAnimation() {
        animationView.stop()
    }
    
    func setupAnimationView() -> LottieAnimationView {
        animationView = .init(name: lottiePath)
        animationView.frame = self.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        return animationView
    }
}
