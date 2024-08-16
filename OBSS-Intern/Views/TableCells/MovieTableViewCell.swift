import UIKit

class MovieTableViewCell: UITableViewCell, ThemeChangeable {
    
    // MARK: --lazy ui variables
    private lazy var movieLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    
    // MARK: --variables
    private let favoriteMovieRepository = FavoriteMovieRepository()
    private var movie: MovieModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        applyTheme(ThemeManager.shared.currentTheme)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundCardView.backgroundColor = nil
        movieNameLabel.text = nil
        movieDescriptionLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
        movieImageView.image = nil
    }
    
    func applyTheme(_ theme: Theme) {
        let textColor = UIColor.clear.themeText(for: theme)

        backgroundCardView.backgroundColor = UIColor.clear.themeCardBackgroundColor(for: theme)
        movieNameLabel.textColor = textColor
        movieDescriptionLabel.textColor = textColor
        ratingLabel.textColor = textColor
        releaseDateLabel.textColor = textColor
    }
    
    func configure(movie: MovieModel) {
        self.movie = movie
        movieImageView.setImage(with: movie.posterPath)
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        releaseDateLabel.text = (movie.releaseDate ?? LocalizationKeys.Common.unkown.localize())
        ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0)
        checkMovieIsFavorite()
    }
    
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
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        backgroundCardView.addSubview(movieImageView)

        // Info Stack View setup
        infoVerticalStackView = UIStackView()
        infoVerticalStackView.axis = .vertical
        infoVerticalStackView.spacing = 4
        infoVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCardView.addSubview(infoVerticalStackView)

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
            
            // Description View
            movieDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
             
            // Calendar Image View constraints
            calendarImageView.widthAnchor.constraint(equalToConstant: 20),
            calendarImageView.heightAnchor.constraint(equalToConstant: 20),

            // Star Image View constraints
            ratingImageView.widthAnchor.constraint(equalToConstant: 20),
            ratingImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
           
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImageView.roundCorners([.topLeft, .bottomLeft], radius: 10)
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
