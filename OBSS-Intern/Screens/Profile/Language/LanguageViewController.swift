//
//  LanguageViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 9.08.2024.
//

import UIKit

struct Language {
    let id: Int
    let name: String
    let flag: UIImage
    let languageCode: String
}

class LanguageViewController: BaseViewController {
    
    // MARK: --variables
    private let languageView: LanguageView = LanguageView()
    
    private var languages: [Language] = [] {
        didSet{loadData()}
    }
    

    // MARK: --override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguages()
        setupUI()
    }
    
    override func setupUI() {
        self.setupNavigation()
        self.configureTableView()
    }
    
    override func updateTheme() {}
    
    override func updateLocalization() {
        setLanguages()
        setupUI()
    }
    
    override func loadView() {
        view = languageView
    }
    
    // MARK: --private functions
    
    private func setupNavigation() {
        self.title = LocalizationKeys.Profile.languageTitle.localize()
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Configuration Methods
    private func configureTableView() {
        self.languageView.languageTableView.dataSource = self
        self.languageView.languageTableView.delegate = self
        self.languageView.languageTableView.register(LanguageCellTableViewCell.self, forCellReuseIdentifier: LanguageCellTableViewCell.identifier)
    }
    
    private func changeLanguage(languageCode: String) {
        let language: SupportedLanguages = SupportedLanguages.tr.getLanguage(languageCode: languageCode)
        LocalizationManager.shared.setLanguage(language: language)
    }
    
    private func setLanguages() {
        languages.removeAll()
        
        languages.append(Language(id: 0, name: LocalizationKeys.Languages.english.localize(), flag: UIImage(named: "english_flag")!, languageCode: "en"))
        languages.append(Language(id: 1, name: LocalizationKeys.Languages.turkish.localize(), flag: UIImage(named: "turkish_flag")!, languageCode: "tr"))
    }

    
    private func loadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.languageView.languageTableView.reloadData()
        }
    }

}

extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCellTableViewCell.identifier, for: indexPath) as? LanguageCellTableViewCell else {
            return UITableViewCell()
        }
        
        let language = languages[indexPath.row]
        cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.configure(model: language)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedLanguage = languages[indexPath.row]
        
        let alertTitle = LocalizationKeys.Profile.changeLanguageTitle.localize()
        let alertMessage = String(format: LocalizationKeys.Profile.changeLanguageMessage.localize(), selectedLanguage.name)
        
        let dialogView = LanguageChangeDialogView(title: alertTitle, message: alertMessage)
        dialogView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(dialogView)

        NSLayoutConstraint.activate([
           dialogView.topAnchor.constraint(equalTo: view.topAnchor),
           dialogView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           dialogView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           dialogView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        dialogView.onCancel = {
            dialogView.removeFromSuperview()
        }

        dialogView.onChange = { [weak self, weak dialogView] in
            self?.changeLanguage(languageCode: selectedLanguage.languageCode)
            dialogView?.removeFromSuperview()
        }
    }
}
