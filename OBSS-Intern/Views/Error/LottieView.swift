//
//  LottieNotFound.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 8.08.2024.
//

import UIKit
import Lottie

class LottieView: UIView {

    public var lottiePath: String = AppImageConstants.kLottie404
    private var animationView: LottieAnimationView!
    private var repeatCount: Int = 999
    
    // MARK: -- required functions
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // get path from init
    init (lottiePath: String, repeatCount: Int = 999) {
        super.init(frame: .zero)
        self.lottiePath = lottiePath
        self.repeatCount = repeatCount
    }
    
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
        animationView.loopMode = repeatCount == 999 ? .loop : .playOnce
        animationView.animationSpeed = 1.0
        animationView.mainThreadRenderingEngineShouldForceDisplayUpdateOnEachFrame = true

        return animationView
    }
}
