//
//  MovieListTableViewCell.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 13.08.2024.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
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
    
    private lazy var listNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var listMovieCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 9)
        return label
    }()
    
    private lazy var bookmarkIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // pick random color
    private var randomColorUIColor: UIColor {
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPink, .systemTeal, .systemIndigo]
        return colors.randomElement() ?? .systemRed
    }
    
    private var gettedRandomColor: UIColor?
    
    // MARK: --required && override functions
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        listNameLabel.text = nil
        iconImageView.image = nil
        iconContainer.backgroundColor = nil
        listMovieCountLabel.text = nil
        bookmarkIconImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(listNameLabel)
        contentView.addSubview(listMovieCountLabel)
        contentView.addSubview(iconContainer)
        contentView.addSubview(bookmarkIconImageView)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        gettedRandomColor = randomColorUIColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 10, y: 6, width: size, height: size)
        
        let imageSize = size / 1.5
        iconImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        iconImageView.center = CGPoint(x: iconContainer.frame.size.width / 2, y: iconContainer.frame.size.height / 2)
        
        listNameLabel.frame = CGRect(
            x: iconContainer.frame.maxX + 10,
            y: 5,
            width: contentView.frame.size.width - iconContainer.frame.maxX - 30,
            height: 20
        )
        
        listMovieCountLabel.frame = CGRect(
            x: iconContainer.frame.maxX + 10,
            y: listNameLabel.frame.maxY + 5,
            width: contentView.frame.size.width - iconContainer.frame.maxX - 20,
            height: 10
        )
        
        bookmarkIconImageView.frame = CGRect(
            x: contentView.frame.size.width - 30,
            y: 0,
            width: 30,
            height: 30
        )
    }
    
    // MARK: --public functions
    func configureCell(list: CustomListEntity, isMovieBookmarked: Bool = false, showRightIcon: Bool = true) {
        listNameLabel.text = list.listName
        listMovieCountLabel.text = "\(list.movies.count) \(LocalizationKeys.MovieList.movies.localize())"
        iconContainer.backgroundColor = gettedRandomColor ?? randomColorUIColor
        iconImageView.image = AppImageConstants.movieClapperImage
        
        if isMovieBookmarked {
            bookmarkIconImageView.image = AppImageConstants.bookmarkFilImage
        }
        
        if showRightIcon{
            accessoryType = .disclosureIndicator
        }
        else{
            accessoryType = .none
        }
    }
    
    // MARK: --private functions
}
