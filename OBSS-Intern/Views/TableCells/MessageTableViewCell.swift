//
//  MessageTableViewCell.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import UIKit

class MessageTableViewCell: UITableViewCell, ThemeChangeable {
    
    // MARK: --lazy variables
    let messageBubble: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.layer.cornerRadius = 10
         view.backgroundColor = .systemBlue
         return view
     }()
     
     let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        return label
     }()
    
    // MARK: --required functions
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: --override functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        
    }
    
    // MARK: --public functions
    func applyTheme(_ theme: Theme) {
        // Theme uygulaması burada yapılabilir
    }
    
    // MARK: --private functions
    private func setupUI() {
        contentView.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageBubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            messageBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            messageBubble.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -8),
        ])
    }
    
    private func setUserMessageConstraints() {
        messageBubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        messageBubble.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 60).isActive = true
    }
    
    private func setBotMessageConstraints() {
        messageBubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        messageBubble.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -60).isActive = true
    }
}
