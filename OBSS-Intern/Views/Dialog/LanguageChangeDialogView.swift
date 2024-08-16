//
//  LanguageChangeDialogView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 9.08.2024.
//

import UIKit

class LanguageChangeDialogView: UIView {

    // MARK: -- lazy ui variables
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKeys.Common.cancel.localize(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKeys.Common.change.localize(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: -- public
    var onCancel: (() -> Void)?
    var onChange: (() -> Void)?
    
    // MARK: -- override and required functions
    init(title: String, message: String) {
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
        
        titleLabel.text = title
        messageLabel.text = message
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(changeTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -- private functions
    private func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(changeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            changeButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            changeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            changeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            changeButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 16),
            changeButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
    
    @objc private func cancelTapped() {
        onCancel?()
    }
    
    @objc private func changeTapped() {
        onChange?()
    }
}
