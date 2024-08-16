//
//  BaseViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 30.07.2024.
//

import Foundation
import UIKit
import Combine

protocol BaseViewControllerProtocol{
    func setupUI()
    func updateLocalization()
    func updateTheme()
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    // did load function
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguageObserver()
        setupThemeObserver()
        setupUI()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // language observer, will be triggered when user changes language
    private func setupLanguageObserver() {
        LocalizationManager.shared.$languageCode
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateLocalization()
            }.store(in: &cancellables)
    }
    
    // theme observer, will be triggered when user changes theme
    private func setupThemeObserver() {
        ThemeManager.shared.$theme
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateTheme()
            }.store(in: &cancellables)
    }
    
    
    // FORCING DEVELOPER TO IMPLEMENT THESE FUNCTIONS
    func setupUI() {
        fatalError("setupUI() has not been implemented")
    }
    
    func updateLocalization() {
        fatalError("updateLocalization() has not been implemented")
    }
    
    func updateTheme() {   
        fatalError("updateTheme() has not been implemented")
    }
}
// PROTOCOL
