//
//  SectionDividerHeaderCollectionReusableView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 5.08.2024.
//

import UIKit

class SectionDividerHeaderView: UICollectionReusableView {
    static let identifier: String = "SectionDividerHeaderView"

    private let titleLabel: UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont.boldSystemFont(ofSize: 18)
         return label
    }()

    override init(frame: CGRect) {
         super.init(frame: frame)
         setupViews()
    }

    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(title: String) {
         titleLabel.text = title
    }

    private func setupViews() {
         addSubview(titleLabel)
        
         NSLayoutConstraint.activate([
             titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
             titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
             titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

         ])
    }
}
