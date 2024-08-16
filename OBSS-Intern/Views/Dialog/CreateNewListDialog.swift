//
//  CreateNewListDialog.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 13.08.2024.
//

import UIKit

class CreateNewListDialog: UIView {

    // MARK: --lazy ui variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationKeys.Profile.createList.localize()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var listTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationKeys.Profile.enterListName.localize()
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKeys.Common.create.localize(), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKeys.Common.cancel.localize(), for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: --public variables
    var onCreateButtonTapped: ((String) -> Void)?
    var onCancelButtonTapped: (() -> Void)?
    
    // MARK: --override and required functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: --private functions
    private func setupView() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 16
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 8
        
        
        addSubview(titleLabel)
        addSubview(listTextField)
        addSubview(createButton)
        addSubview(cancelButton)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        // Layout Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            listTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            listTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            listTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            listTextField.heightAnchor.constraint(equalToConstant: 44),
            
            createButton.topAnchor.constraint(equalTo: listTextField.bottomAnchor, constant: 20),
            createButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 24),
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: --objc functions
    @objc private func createButtonTapped() {
        if let text = listTextField.text, !text.isEmpty {
            onCreateButtonTapped?(text)
        }
    }
    
    @objc private func cancelButtonTapped() {
        self.onCancelButtonTapped?()
    }
}

extension CreateNewListDialog {
    private struct AssociatedKeys {
        static var overlayViewKey = "OverlayViewKey"
    }
    
    private var overlayView: UIView? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.overlayViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.overlayViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func show(in viewController: UIViewController, onCreateButtonTapped: @escaping (String) -> Void) {
        self.onCreateButtonTapped = { [weak self] text in
            onCreateButtonTapped(text)
            self?.dismiss()
        }
        
        self.onCancelButtonTapped = { [weak self] in
            self?.dismiss()
        }
        
        overlayView = UIView(frame: viewController.view.bounds)
        overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView?.alpha = 0
        
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let overlayView = overlayView {
            viewController.view.addSubview(overlayView)
        }
        
        viewController.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor, constant: -25),
            self.widthAnchor.constraint(equalToConstant: 300),
            self.heightAnchor.constraint(equalToConstant: 225)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.overlayView?.alpha = 1
            self.alpha = 1
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView?.alpha = 0
            self.alpha = 0
        }) { _ in
            self.overlayView?.removeFromSuperview()
            self.overlayView = nil
            self.removeFromSuperview()
        }
    }
}
