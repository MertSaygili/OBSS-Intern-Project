//
//  SettingsViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 30.07.2024.
//

import UIKit
import RealmSwift

struct ProfileSection{
    let title: String
    let options: [ProfileSectionType]
}

enum ProfileSectionType {
    case staticCell(model: ProfileOption)
    case switchCell(model: ProfileSwitchOption)
}

struct ProfileOption {
    let title: String
    let icon: UIImage
    let iconBackground: UIColor
    let showRightArrow: Bool
    let handler: (() -> Void)
}

struct ProfileSwitchOption {
    let title: String
    let icon: UIImage
    let iconBackground: UIColor
    let isOn: Bool
    let handler: (() -> Void)
}

class ProfileViewController: BaseViewController {
    
    // MARK: --variables
    private let profileView: ProfileView = ProfileView()
    private let screenNavigationManager: ScreenNavigationManagerProtocol = ScreenNavigationManager()
    private let customListRepository: CustomListRepositoryProtocol = CustomListRepository()
    
    private var currentTheme: Theme = ThemeManager.shared.currentTheme
    private var models: [ProfileSection] = [] {
        didSet{loadData()}
    }
    
    // MARK: --override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func setupUI() {
        self.setupNavigation()
        self.setupTableView()
        self.profileView.applyTheme(currentTheme)
        self.profileView.tableView.reloadData()
    }
    
    override func updateTheme() {
        self.setupUI()
        self.configure()
        self.profileView.tableView.reloadData()
    }
    
    override func updateLocalization() {
        setupUI()
        configure()
    }
    
    // MARK: --public functions
    func configure() {
        models.removeAll()
        
        let themeIcon = currentTheme == Theme.dark ? AppImageConstants.kMoon :  AppImageConstants.kSun
        let themeBackground: UIColor = currentTheme == Theme.dark ? .systemBlue : .systemYellow
        let themeSwitchStatus: Bool = currentTheme == Theme.dark ? false : true
        
        // List
        models.append(ProfileSection(title: LocalizationKeys.Profile.profileList.localize(), options: [
                .staticCell(model: ProfileOption(title: LocalizationKeys.Profile.createList.localize(), icon: UIImage(systemName: AppImageConstants.kPlus)!, iconBackground: .systemBlue, showRightArrow: false){
                    self.showDialog(onCreateButtonTapped: {text in self.createNewList(listName: text)})
                }),
                .staticCell(model: ProfileOption(title: LocalizationKeys.Profile.displayList.localize(), icon: UIImage(systemName: AppImageConstants.kList)!, iconBackground: .systemRed, showRightArrow: true){
                        self.pushToMovieLists()
                }),
            ])
        )
        
        // General
        models.append(
            ProfileSection(title: LocalizationKeys.Profile.generalTitle.localize(), options: [
                .staticCell(model: ProfileOption(title: LocalizationKeys.Profile.deviceLanguage.localize(), icon: UIImage(systemName: AppImageConstants.kGlobe)!, iconBackground: .systemBlue, showRightArrow: true){
                    self.pushLanguageScreen()
                }),
                .switchCell(model: ProfileSwitchOption(title: LocalizationKeys.Profile.deviceBrightness.localize(), icon: UIImage(systemName: themeIcon)!,  iconBackground: themeBackground, isOn: themeSwitchStatus){
                    [weak self] in self?.changeTheme()
                }),
            ])
        )
        
        // Information
        models.append(
            ProfileSection(title: LocalizationKeys.Profile.informationTitle.localize(), options: [
                .staticCell(model: ProfileOption(title: LocalizationKeys.Profile.contactUs.localize(), icon: UIImage(systemName: AppImageConstants.kPaperplane)!, iconBackground: .systemGreen, showRightArrow: false){
                    self.showToast(message: LocalizationKeys.Profile.mailUs.localize(), y: Double(self.view.frame.size.height - 175), height: 70)
                }),
              
            ])
        )
    }
    
    // MARK: --private functions
    private func setupNavigation() {
        if let navController = self.navigationController {
            self.profileView.setUpNavigationBar(navigationItem: self.navigationItem, navigationController: navController)
        }
    }
    
    private func setupTableView() {
        self.profileView.tableView.dataSource = self
        self.profileView.tableView.delegate = self
        self.profileView.tableView.frame = view.bounds
        self.profileView.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        self.profileView.tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
    }
    
    private func pushLanguageScreen() {
        if let navController = self.navigationController {
            screenNavigationManager.pushToLanguage(navigationController: navController)
        }
    }
    
    private func loadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.profileView.tableView.reloadData()
        }
    }
    
    private func changeTheme() {
        switch currentTheme{
        case Theme.light:
            ThemeManager.shared.currentTheme = Theme.dark
            currentTheme = Theme.dark
        case Theme.dark:
            ThemeManager.shared.currentTheme = Theme.light
            currentTheme = Theme.light
        }
    }
    
    private func createNewList(listName: String) {
        customListRepository.createCustomList(listName: listName)
    }
    
    private func pushToMovieLists() {
        if let navController = self.navigationController {
            screenNavigationManager.pushMovieLists(navigationController: navController)
        }
    }
        
    func showDialog(onCreateButtonTapped: @escaping (String) -> Void) {
        let alertView = CreateNewListDialog()
        alertView.show(in: self) { newListName in
            onCreateButtonTapped(newListName)
        }
    }
}

// MARK: Table View Extensions
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self{
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(model: model)
            
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(model: model)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
                
        switch model.self{
        case .staticCell(let model):
            model.handler()
        case .switchCell(_):
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
}
