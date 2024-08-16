//
//  AnimatedFlaotingActionButton.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 11.08.2024.
//

import UIKit
import UIKit

class AnimatedFloatingActionButton: UIButton {
    
    // MARK: --lazy variables
    lazy var button: UIView = {
        let button = UIButton()
        return button
    }()
    
    // MARK: --private variables
    private let buttonSize: CGFloat = 56
    private let buttonMargin: CGFloat = 16
    
    private var pulseLayer: CAShapeLayer?
    
    // MARK: --getter and setters
    var buttonImage: UIImage {
        set{
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .default)
            setImage(newValue.withConfiguration(config), for: .normal)
            imageView?.contentMode = .scaleAspectFit
            
            self.layoutIfNeeded()
            self.layoutSubviews()
        }
        get{
            return UIImage(systemName: "plus")!
        }
    }
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    // MARK: --public functions
    func addToView(_ view: UIView) {
        view.addSubview(button)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -buttonMargin),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonMargin),
            widthAnchor.constraint(equalToConstant: buttonSize),
            heightAnchor.constraint(equalToConstant: buttonSize)
        ])
    }
    
    // MARK: --objc functions
    @objc private func buttonTapped() {
        animatePulse()
    }
    
    // MARK: --private functions
    private func setupButton() {
        frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        layer.cornerRadius = buttonSize / 2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        backgroundColor = .systemBlue
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .default)
        setImage(UIImage(systemName: "plus")?.withConfiguration(config), for: .normal)
        
        tintColor = .white
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func animatePulse() {
        pulseLayer?.removeFromSuperlayer()
        
        let pulse = CAShapeLayer()
        pulse.frame = bounds
        pulse.cornerRadius = buttonSize / 2
        pulse.backgroundColor = UIColor.white.cgColor
        pulse.opacity = 0.5
        
        layer.insertSublayer(pulse, below: layer)
        pulseLayer = pulse
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.2
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = 1
        animation.autoreverses = true
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.6
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        opacityAnimation.repeatCount = 1
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = .forwards
        
        pulse.add(animation, forKey: "pulse")
        pulse.add(opacityAnimation, forKey: "opacity")
    }
}
