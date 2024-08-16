//
//  SwitchTableViewCell.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 9.08.2024.
//

import UIKit

class SwitchTableViewCell: UITableViewCell, ThemeChangeable {
    
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
    
    private lazy var settingsSwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemBlue
        mySwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        return mySwitch
    }()
    
    private var switchAction: (() -> Void)?
    
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
        contentView.addSubview(settingsSwitch)
        accessoryType = .none
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 10, y: 6, width: size, height: size)
        
        let imageSize = size / 1.5
        iconImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        iconImageView.center = CGPoint(x: iconContainer.frame.size.width / 2, y: iconContainer.frame.size.height / 2)
        
        settingsSwitch.sizeToFit()
        settingsSwitch.frame = CGRect(
            x: (contentView.frame.size.width - settingsSwitch.frame.size.width) - 20,
            y: (contentView.frame.size.height - settingsSwitch.frame.size.width) / 2 + 10,
            width: settingsSwitch.frame.size.width,
            height: settingsSwitch.frame.size.height
        )
        
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
        settingsSwitch.isOn = false
    }
    
    // MARK: --public functions
    func configure(model: ProfileSwitchOption) {
        contentLabel.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackground
        settingsSwitch.isOn = model.isOn
        switchAction = model.handler
    }
    
    func applyTheme(_ theme: Theme) {
        backgroundColor = UIColor.clear.themeBackground(for: theme)
        contentLabel.textColor = UIColor.label.themeText(for: theme)
    }
    
    // MARK: --@objc fuctions
    @objc private func switchToggled(_ sender: UISwitch) {
        switchAction?()
    }
}
