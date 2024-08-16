//
//  SettingsTableViewCell.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 9.08.2024.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, ThemeChangeable {
    
    // MARK: --lazy ui variables
    private lazy var iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: --required functions
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: --override functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentLabel)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 10, y: 6, width: size, height: size)
        
        let imageSize = size / 1.5
        iconImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        iconImageView.center = CGPoint(x: iconContainer.frame.size.width / 2, y: iconContainer.frame.size.height / 2)
        
        contentLabel.frame = CGRect(
            x: 20 + iconContainer.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.text = nil
        iconImageView.image = nil
        iconContainer.backgroundColor = nil
    }
    
    // MARK: --public functions
    func configure(model: ProfileOption) {
        contentLabel.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackground
        
        if !model.showRightArrow {
            accessoryType = .none
        }
        else{
            accessoryType = .disclosureIndicator
        }
    }
    
    func applyTheme(_ theme: Theme) {
        backgroundColor = UIColor.clear.themeBackground(for: theme)
        contentLabel.textColor = UIColor.label.themeText(for: theme)
    }
}
