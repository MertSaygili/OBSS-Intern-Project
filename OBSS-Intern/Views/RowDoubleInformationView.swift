//
//  RowTextIconView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 2.08.2024.
//

import UIKit

class RowDoubleInformationView: UIView {
    static let identifier: String = "RowDoubleInformationView"
    
    let rowStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var leadingIconTextView: IconTextView = {
        let view = IconTextView(imageName: "", text: "", iconColor: .gray)
        return view
    }()
    
    lazy var trailingIconTextView: IconTextView = {
        let view = IconTextView(imageName: "", text: "", isReverse: true, iconColor: .gray)
        return view
    }()
    
    init(leadingText: String, trailingText: String, leadingIcon: String, trailingIcon: String, leadingIconColor: UIColor, trailingIconColor: UIColor) {
        super.init(frame: .zero)
        configureLeading(leadingText: leadingText, leadingIcon: leadingIcon, color: leadingIconColor)
        configureTrailing(trailingText: trailingText, trailingIcon: trailingIcon, color: trailingIconColor)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributes(leadingText: String, trailingText: String, leadingIcon: String, trailingIcon: String) {
        configureLeading(leadingText: leadingText, leadingIcon: leadingIcon, color: nil)
        configureTrailing(trailingText: trailingText, trailingIcon: trailingIcon, color: nil)
    }
    
    private func setupView() {
        addSubview(rowStackView)
        rowStackView.addArrangedSubview(leadingIconTextView)
        rowStackView.addArrangedSubview(trailingIconTextView)
        
        NSLayoutConstraint.activate([
            rowStackView.topAnchor.constraint(equalTo: topAnchor),
            rowStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rowStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rowStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureLeading(leadingText: String, leadingIcon: String, color: UIColor?) {
        leadingIconTextView.setImage(imageName: leadingIcon)
        leadingIconTextView.setText(leadingText, .darkGray)
        guard let newColor = color else {return}
        leadingIconTextView.setIconColor(color: newColor)
        
    }
    
    private func configureTrailing(trailingText: String, trailingIcon: String, color: UIColor?) {
        trailingIconTextView.setImage(imageName: trailingIcon)
        trailingIconTextView.setText(trailingText, .darkGray)
        guard let newColor = color else {return}
        trailingIconTextView.setIconColor(color: newColor)
        
    }
    
}
