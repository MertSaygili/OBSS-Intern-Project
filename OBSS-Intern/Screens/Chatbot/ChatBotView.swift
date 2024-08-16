//
//  ChatBotView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 11.08.2024.
//

import UIKit
import MessageKit

class ChatBotView: UIView {
    // MARK: --lazy variables
        
    // MARK: --required functions
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    // MARK: --public functions
    
    
    // MARK: --private functions
    private func setupViews() {
    }
    
    
    private func setupConstraints() {
    }
}
