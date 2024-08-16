//
//  ViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 22.07.2024.
//

import UIKit
import Lottie

class SplashController: BaseViewController {
    
    // MARK: - Properties
    private let screenNavigationManager: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    
    // MARK: --lazy ui variables
    lazy var lottieSplash: LottieAnimationView = {
        let view = LottieView(lottiePath: AppImageConstants.kLottieSplash, repeatCount: 1).setupAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.configuration.renderingEngine = RenderingEngineOption.specific(.mainThread)
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.75){
            self.transitionToTabBarController()
        }
    }
    
    private func transitionToTabBarController() {
        guard let navController = self.navigationController else {return}
        screenNavigationManager.pushHome(navigationController: navController)
    }
    
    override func setupUI() {
        setUpConstraints()
        lottieSplash.isHidden = false
        lottieSplash.play()
    }
    
    override func updateTheme() {}
    
    override func updateLocalization() {}
    
    private func setUpConstraints() {
        view.addSubview(lottieSplash)
        
        NSLayoutConstraint.activate([
            lottieSplash.topAnchor.constraint(equalTo: view.topAnchor),
            lottieSplash.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lottieSplash.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lottieSplash.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

