//
//  SettingsView.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 9.08.2024.
//

import UIKit

class ProfileView: UIView{
    
    // MARK: --lazy ui variables
    lazy var screenView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.bounces = false
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    lazy var createNewListDialog: CreateNewListDialog = {
       let dialog = CreateNewListDialog()
        dialog.translatesAutoresizingMaskIntoConstraints = false
        dialog.onCreateButtonTapped = { [weak self] text in
                print("olustur, tiklandi, \(text)")
        }
        return dialog
    }()
    
    var overlayView: UIView?

    // MARK: --required functions
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: --override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        applyTheme(ThemeManager.shared.currentTheme)
    }
    
    // MARK: --public functions
    func setUpNavigationBar(navigationItem: UINavigationItem, navigationController: UINavigationController) {
        navigationItem.title = LocalizationKeys.Profile.profileTitle.localize()
        
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
    
    func applyTheme(_ theme: Theme) {
        let backgroundColor = UIColor.clear.themeBackground(for: theme)
        screenView.backgroundColor = backgroundColor
        tableView.backgroundColor = backgroundColor
        
        for case let cell as ThemeChangeable in tableView.visibleCells {
            cell.applyTheme(theme)
        }
        
        for section in 0..<tableView.numberOfSections {
            if let headerView = tableView.headerView(forSection: section) as? ThemeChangeable {
                headerView.applyTheme(theme)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: --private functions
    private func setupViews() {
        addSubview(screenView)
        screenView.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Screen View Constraints
            screenView.topAnchor.constraint(equalTo: topAnchor),
            screenView.leadingAnchor.constraint(equalTo: leadingAnchor),
            screenView.trailingAnchor.constraint(equalTo: trailingAnchor),
            screenView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Table View Constraints
            tableView.topAnchor.constraint(equalTo: screenView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: screenView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: screenView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: screenView.bottomAnchor),
        ])
    }
    
    private func dismissCustomAlert(_ alertView: CreateNewListDialog) {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView?.alpha = 0
            alertView.alpha = 0
            }) { _ in
                self.overlayView?.removeFromSuperview()
                self.overlayView = nil
                alertView.removeFromSuperview()
        }
    }
}
