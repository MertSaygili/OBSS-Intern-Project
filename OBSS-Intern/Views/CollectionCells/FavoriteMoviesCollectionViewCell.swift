//
//  FavoriteMoviesCollectionViewCell.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 9.08.2024.
//

import UIKit

class FavoriteMoviesCollectionViewCell: UICollectionViewCell, ThemeChangeable {
    
    // MARK: --varibles
    private var backgroundCardView: UIView!
    private var movieImageView: UIImageView!
    
    // MARK: --required functions
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
        roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }
    
    // MARK: --public functions
    func configure(movie: MovieEntity) {
        movieImageView.setImage(with: movie.movieImagePath)
    }
    
    func applyTheme(_ theme: Theme) {
        backgroundCardView.backgroundColor = UIColor.clear.themeCardBackgroundColor(for: theme)
    }
    
    // MARK: --private functions
    private func setupViews() {
        // Background card view setup
        backgroundCardView = UIView()
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCardView.backgroundColor = .white
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.layer.shadowColor = UIColor.black.cgColor
        backgroundCardView.layer.shadowOpacity = 0.2
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundCardView.insetsLayoutMarginsFromSafeArea = false
        backgroundCardView.layer.shadowRadius = 4
        contentView.addSubview(backgroundCardView)
        
        // ImageView setup
        movieImageView = UIImageView()
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.contentMode = .scaleToFill
        movieImageView.clipsToBounds = true
        contentView.addSubview(movieImageView)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Background card view constraints
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backgroundCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // movieImageView constraints
            movieImageView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalTo: backgroundCardView.heightAnchor, multiplier: 1),
        
        ])
    }
}
