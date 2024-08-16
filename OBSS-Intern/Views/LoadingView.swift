//
//  LoadingView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 5.08.2024.
//

import UIKit

class LoadingView: UIView, ThemeChangeable {
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: --required functions
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: --public functions
    func applyTheme(_ theme: Theme) {
        activityIndicator.color = UIColor.clear.themeText(for: theme)
    }
    
    func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: --private functions
    private func setupView() {
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20)
        ])
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
}

