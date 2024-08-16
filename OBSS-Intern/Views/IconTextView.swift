import UIKit

class IconTextView: UIView {
    private var isReverse: Bool = false
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .link
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }

    init(imageName: String, text: String, isReverse: Bool = false, iconColor: UIColor) {
        super.init(frame: .zero)
        iconImageView.image = UIImage(systemName: imageName)
        textLabel.text = text
        self.isReverse = isReverse
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setText(_ text: String, _ color: UIColor?) {
        textLabel.text = text
        textLabel.textColor = color
    }
    
    func setImage(imageName: String) {
        iconImageView.image = UIImage(systemName: imageName)
    }
    
    func setIconColor(color: UIColor){
        iconImageView.tintColor = color
    }

    private func setupView() {
        if self.isReverse {
            addSubview(textLabel)
            addSubview(iconImageView)
            
            NSLayoutConstraint.activate([
                textLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -4),
                textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                
                iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 20),
                iconImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        } else {
            addSubview(iconImageView)
            addSubview(textLabel)
            
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 20),
                iconImageView.heightAnchor.constraint(equalToConstant: 20),

                textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
                textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}
