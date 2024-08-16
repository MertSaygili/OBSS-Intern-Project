import UIKit
import Combine

class PopularMoviesCollectionViewCell: UICollectionViewCell, ThemeChangeable {
    
    // MARK: --variables
    private let favoriteMovieRepository: FavoriteMovieRepositoryProtocol = FavoriteMovieRepository()
    private var movie: MovieModel?
    
    // MARK: --ui variables
    private var backgroundCardView: UIView!
    private var movieImageView: UIImageView!
    
    private var infoVerticalStackView: UIStackView!
    private var movieNameLabel: UILabel!
    private var movieDescriptionLabel: UILabel!
    
    private var dateHorizontalStackView: UIStackView!
    private var releaseDateLabel: UILabel!
    private var calendarImageView: UIImageView!
    
    private var rateLikeHorizontalStackView: UIStackView!
    private var heartImageView: UIImageView!
    private var ratingStackView: UIStackView!
    private var ratingLabel: UILabel!
    private var ratingImageView: UIImageView!
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        applyTheme(ThemeManager.shared.currentTheme)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImageView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        movieNameLabel.text = nil
        movieDescriptionLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
    }

    // MARK: --required functions
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: --public functions
    
    func applyTheme(_ theme: Theme) {
        let textColor: UIColor = UIColor.clear.themeText(for: theme)
        movieNameLabel.textColor = textColor
        movieDescriptionLabel.textColor = textColor
        releaseDateLabel.textColor = textColor
        ratingLabel.textColor = textColor
        backgroundCardView.backgroundColor = UIColor.clear.themeCardBackgroundColor(for: theme)
    }
    
    func configure(movie: MovieModel) {
        self.movie = movie
        
        guard let posterPath = movie.posterPath else {
            movieImageView.image = AppImageConstants.posterPlaceholderImage
            return
        }
        
        let image: String = posterPath.getW500Image
        
        if let url = URL(string: image) {
            movieImageView.kf.setImage(with: url, placeholder: AppImageConstants.posterPlaceholderImage)
        } else {
            movieImageView.image = AppImageConstants.posterPlaceholderImage
        }
        
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        releaseDateLabel.text = (movie.releaseDate?.toFormattedDateString() ?? LocalizationKeys.Common.unkown.localize())
        ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0)
        checkMovieIsFavorite()
    }
    
    // MARK: --private functions
    private func setupViews() {
        // Background card view setup
        backgroundCardView = UIView()
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
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

        // Info Stack View setup
        infoVerticalStackView = UIStackView()
        infoVerticalStackView.axis = .vertical
        infoVerticalStackView.spacing = 8
        infoVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoVerticalStackView)

        // Movie Name Label setup
        movieNameLabel = UILabel()
        movieNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        movieNameLabel.numberOfLines = 2
        infoVerticalStackView.addArrangedSubview(movieNameLabel)

        // Movie Description Label setup
        movieDescriptionLabel = UILabel()
        movieDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        movieDescriptionLabel.numberOfLines = 4
        infoVerticalStackView.addArrangedSubview(movieDescriptionLabel)
        
        // Date Horizontal Stack View setup
        dateHorizontalStackView = UIStackView()
        dateHorizontalStackView.axis = .horizontal
        dateHorizontalStackView.spacing = 4
        dateHorizontalStackView.alignment = .center
        infoVerticalStackView.addArrangedSubview(dateHorizontalStackView)
        
        calendarImageView = UIImageView()
        calendarImageView = UIImageView(image: AppImageConstants.calendarImage)
        calendarImageView.tintColor = .link
        calendarImageView.contentMode = .scaleAspectFit
        dateHorizontalStackView.addArrangedSubview(calendarImageView)
        
        // Release Date Label setup
        releaseDateLabel = UILabel()
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        releaseDateLabel.textColor = .gray
        dateHorizontalStackView.addArrangedSubview(releaseDateLabel)
        
        // Rate Like Horizontal Stack View setup
        rateLikeHorizontalStackView = UIStackView()
        rateLikeHorizontalStackView.axis = .horizontal
        rateLikeHorizontalStackView.spacing = 4
        rateLikeHorizontalStackView.alignment = .center
        infoVerticalStackView.addArrangedSubview(rateLikeHorizontalStackView)
        
        // Rating Image View setup
        ratingImageView = UIImageView()
        ratingImageView = UIImageView(image: AppImageConstants.starImage)
        ratingImageView.tintColor = .link
        ratingImageView.contentMode = .scaleAspectFit
        rateLikeHorizontalStackView.addArrangedSubview(ratingImageView)
        
        // Rating Label setup
        ratingLabel = UILabel()
        ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        rateLikeHorizontalStackView.addArrangedSubview(ratingLabel)
        
        
        // Heart Image View setup
        heartImageView = UIImageView(image: AppImageConstants.heartImage)
        heartImageView.tintColor = .red
        heartImageView.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        heartImageView.isUserInteractionEnabled = true
        heartImageView.addGestureRecognizer(tapGesture)
        
        
        rateLikeHorizontalStackView.addArrangedSubview(heartImageView)
        
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
            movieImageView.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 120),

            // Info Stack View constraints
            infoVerticalStackView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 10),
            infoVerticalStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            infoVerticalStackView.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -10),
            infoVerticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundCardView.bottomAnchor, constant: -10),
             
            movieDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Calendar Image View constraints
            calendarImageView.widthAnchor.constraint(equalToConstant: 20),
            calendarImageView.heightAnchor.constraint(equalToConstant: 20),

            // Star Image View constraints
            ratingImageView.widthAnchor.constraint(equalToConstant: 20),
            ratingImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
        
    private func changeFavoriteStatus() {
        guard let movie = self.movie else {return}
        
        let status: Bool = favoriteMovieRepository.isMovieExists(id: movie.id)
        
        if status {
            favoriteMovieRepository.deleteFavoriteMovie(id: movie.id)
        }
        else{
            let entity = MovieEntity()
            entity.movieId = movie.id
            entity.movieName = movie.title
            entity.movieImagePath = movie.posterPath
            
            favoriteMovieRepository.addFavoriteMovie(movie: entity)
        }
        checkMovieIsFavorite()
    }
    
    private func checkMovieIsFavorite() {
        guard let movie = movie else { return }

        let status: Bool = favoriteMovieRepository.isMovieExists(id: movie.id)
        
        if status {
            heartImageView.image = AppImageConstants.heartFillImage
        } else {
            heartImageView.image = AppImageConstants.heartImage
        }
    }
    
    // MARK: --@objc functions
    @objc private func favoriteButtonTapped() {
        self.changeFavoriteStatus()
    }
}
