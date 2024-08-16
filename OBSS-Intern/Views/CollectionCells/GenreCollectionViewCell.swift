import UIKit

class InsetLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 8, left: 12, bottom: 4, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}


class GenreCollectionViewCell: UICollectionViewCell, ThemeChangeable {
    
    // MARK: --lazy ui variables
    lazy var uiContainerView: UIView = {
        let view = InsetLabel()
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 10
        view.backgroundColor = .link
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.layoutMargins = UIEdgeInsets.init(top: 5, left: 12, bottom: 5, right: 12)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: --required functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreLabel.text = nil
    }
    
    
    // MARK: --required
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    // MARK: --public
    func configure(genreName: String){
        genreLabel.text = genreName
    }
    
    func applyTheme(_ theme: Theme) {
        genreLabel.textColor = UIColor.clear.themeText(for: theme)
        uiContainerView.backgroundColor = UIColor.clear.themeCardBackgroundColor(for: theme)
    }
    
    // MARK: --private
    private func setupViews() {
        contentView.addSubview(uiContainerView)
        uiContainerView.addSubview(genreLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view constraints
            uiContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            uiContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            uiContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
            uiContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            
            // Genre label constraints
            genreLabel.topAnchor.constraint(equalTo: uiContainerView.topAnchor, constant: 8),
            genreLabel.bottomAnchor.constraint(equalTo: uiContainerView.bottomAnchor, constant: -8),
            genreLabel.leadingAnchor.constraint(equalTo: uiContainerView.leadingAnchor, constant: 8),
            genreLabel.trailingAnchor.constraint(equalTo: uiContainerView.trailingAnchor, constant: -8)
        ])
    }
}
