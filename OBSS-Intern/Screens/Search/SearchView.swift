import UIKit

class SearchView: UIView{
    // MARK: --lazy variables
    lazy var screenView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.autocorrectionType = UITextAutocorrectionType.no
        searchBar.keyboardType = UIKeyboardType.webSearch
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.layoutMargins = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        searchBar.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 5)
        searchBar.searchTextPositionAdjustment = .init(horizontal: 5, vertical: 0)
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none

        return searchBar
    }()
    
    lazy var movieTableView: UITableView = {
        let uiTableView = UITableView(frame: .zero)
        uiTableView.translatesAutoresizingMaskIntoConstraints = false
        uiTableView.showsVerticalScrollIndicator = false
        uiTableView.bounces = false
        return uiTableView
    }()
    
    lazy var floatingAIChatButton: UIButton = {
        let button = AnimatedFloatingActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonImage = AppImageConstants.chatBotImage
        return button
    }()
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    // MARK: --required functions
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: --public functions
    func setUpNavigationBar(navigationItem: UINavigationItem, navigationController: UINavigationController) {
        navigationItem.title = LocalizationKeys.Search.searchTitle.localize()
        
        let appearance = UINavigationBarAppearance()
        let currentTheme = ThemeManager.shared.currentTheme
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear.themeBackground(for: currentTheme)
        appearance.titleTextAttributes = [.foregroundColor: currentTheme == Theme.dark ? UIColor.white : UIColor.black, .font: UIFont.boldSystemFont(ofSize: 18)]
        appearance.shadowColor = currentTheme == Theme.dark ? UIColor.white : UIColor.black

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureTexts() {
        self.movieSearchBar.placeholder = LocalizationKeys.Search.searchPlaceholder.localize()
    }
    
    func applyTheme(_ theme: Theme) {
        let backgroundColor = UIColor.clear.themeBackground(for: theme)
        let textColor = UIColor.clear.themeText(for: theme)
        
        screenView.backgroundColor = backgroundColor
        
        if theme == .dark {
            movieSearchBar.searchTextField.backgroundColor = .lightGray.withAlphaComponent(0.25)
            movieSearchBar.searchTextField.textColor = .white
            movieSearchBar.searchTextField.tintColor = .white
            movieSearchBar.searchTextField.tokenBackgroundColor = .white
            movieSearchBar.backgroundColor = backgroundColor
            movieSearchBar.barTintColor = backgroundColor
            
            if let textField = movieSearchBar.value(forKey: "searchField") as? UITextField {
                if let iconView = textField.leftView as? UIImageView {
                    iconView.tintColor = .white
                }
                textField.attributedPlaceholder = NSAttributedString(
                    string: textField.placeholder ?? LocalizationKeys.Search.searchPlaceholder.localize(),
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                )
            }
        } else {
            movieSearchBar.searchTextField.backgroundColor = .lightGray.withAlphaComponent(0.25)
            movieSearchBar.searchTextField.textColor = textColor
            movieSearchBar.searchTextField.tintColor = .lightGray.withAlphaComponent(0.1)
            movieSearchBar.searchTextField.tokenBackgroundColor = .black
            movieSearchBar.backgroundColor = backgroundColor
            movieSearchBar.barTintColor = backgroundColor
            
            if let textField = movieSearchBar.value(forKey: "searchField") as? UITextField {
                if let iconView = textField.leftView as? UIImageView {
                    iconView.tintColor = .black
                }
                textField.attributedPlaceholder = NSAttributedString(
                    string: textField.placeholder ?? LocalizationKeys.Search.searchPlaceholder.localize(),
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
                )
            }
        }

        for case let cell as ThemeChangeable in movieTableView.visibleCells {
            cell.applyTheme(theme)
        }
        
        movieTableView.reloadData()
    }

    // MARK: --private functions
    private func setupViews() {
        addSubview(screenView)
        screenView.addSubview(movieSearchBar)
        screenView.addSubview(floatingAIChatButton)
        screenView.addSubview(movieTableView)
        
        screenView.bringSubviewToFront(floatingAIChatButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            screenView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            screenView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            screenView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            screenView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            movieSearchBar.topAnchor.constraint(equalTo: screenView.topAnchor, constant: 20),
            movieSearchBar.leadingAnchor.constraint(equalTo: screenView.leadingAnchor),
            movieSearchBar.trailingAnchor.constraint(equalTo: screenView.trailingAnchor),
            movieSearchBar.heightAnchor.constraint(equalToConstant: 40),
            
            movieTableView.topAnchor.constraint(equalTo: movieSearchBar.bottomAnchor, constant: 10),
            movieTableView.leadingAnchor.constraint(equalTo: screenView.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: screenView.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: screenView.bottomAnchor),
            
            floatingAIChatButton.trailingAnchor.constraint(equalTo: screenView.trailingAnchor, constant: -16),
            floatingAIChatButton.bottomAnchor.constraint(equalTo: screenView.bottomAnchor, constant: -16),
            floatingAIChatButton.widthAnchor.constraint(equalToConstant: 64),
            floatingAIChatButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}
