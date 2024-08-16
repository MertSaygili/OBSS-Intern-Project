//
//  ChatBotViewController.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 11.08.2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Combine

struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    let sender: SenderType
    let messageId: String
    let sentDate: Date
    var kind: MessageKind
}

class ChatBotViewController: MessagesViewController, BaseViewControllerProtocol {
    
    // MARK: --variables
    private let chatBotService: ChatBotServiceProtocol = ChatBotService()
    private let userAvatar = ChatBotAvatars.userAvatarList.randomElement()
    private let userRepo: UserRepositoryProtocol = UserRepository()
    private let chatBotRepository: ChatBotRepositoryProtocol = ChatBotRepository()

    
    private var messages: [MessageType] = []
    private var currentMessage: Message?
    private var cancellables = Set<AnyCancellable>()
    private var currentUser: Sender = Sender(senderId: "1", displayName: "1")
    private var aiUser: Sender = Sender(senderId: "2", displayName: "2")
    private var sessionId: Int = 1
    
    // MARK: --required functions
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: --override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
        getUsers()
        fetchMessages()
        setupUI()
        setDismissKeyboard()
        setupLanguageObserver()
        setupThemeObserver()
    }
    
    func setupUI() {
        setUpNavigationBar()
        setupMessagesCollectionView()
    }
    
    func updateLocalization() {
        setupMessagesCollectionView()
        setUpNavigationBar()
    }
    
    func updateTheme() {
        setupMessagesCollectionView()
    }
    
    // MARK: --public functions
    
    // MARK: --private functions
    private func createSession() {
        sessionId = chatBotRepository.getLastSession()
    }
    
    private func getUsers() {
        let userEntity = userRepo.getUser(userId: UIDevice.current.identifierForVendor?.uuidString ?? "")
        let aiEntity = userRepo.getUser(userId: "\(UIDevice.current.identifierForVendor?.uuidString ?? "")-bot")
        
        currentUser = Sender(senderId: userEntity?.userId ?? "", displayName: userEntity?.userName ?? "")
        aiUser = Sender(senderId: aiEntity?.userId ?? "", displayName: aiEntity?.userName ?? "")
    }
    
    private func fetchMessages() {
        let dbMessages = chatBotRepository.getMessages(sessionId: sessionId)
        for message in dbMessages {
            let sender = message.senderId == currentUser.senderId ? currentUser : aiUser
            let kind = MessageKind.text(message.message)
            let date = message.sendDate
            
            let message = Message(sender: sender, messageId: message.messageId, sentDate: date, kind: kind)
            messages.append(message)
        }
        
        if messages.isEmpty {
            let welcomeMessage = Message(sender: aiUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(LocalizationKeys.ChatBot.welcomeMessage.localize()))
            messages.append(welcomeMessage)
        }
        
        messagesCollectionView.reloadData()
    }
    
    private func addMessageToDb(message: MessageType, text: String) {
        let newMessage = ChatBotMessageEntity()
        newMessage.messageId = message.messageId
        newMessage.senderId = message.sender.senderId
        newMessage.senderName = message.sender.displayName
        newMessage.message = text
        newMessage.sendDate = message.sentDate
        
        
        chatBotRepository.addMessage(sessionId: sessionId, message: newMessage)
    }
    
    private func setupMessagesCollectionView() {
        let theme = ThemeManager.shared.currentTheme
        
        let bgColor = UIColor.clear.themeBackground(for: theme)
        let textColor = UIColor.clear.themeText(for: theme)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        // ui settings
        messagesCollectionView.showsVerticalScrollIndicator = false
        messagesCollectionView.contentInset.bottom = 15
        messagesCollectionView.contentInset.top = 15
        messagesCollectionView.backgroundColor = bgColor
        messageInputBar.inputTextView.backgroundColor = bgColor
        messageInputBar.inputTextView.textColor = textColor
        messageInputBar.inputTextView.placeholderLabel.text = LocalizationKeys.ChatBot.writeMessage.localize()
        messageInputBar.inputTextView.placeholderLabel.textColor = textColor
        messageInputBar.inputTextView.tintColor = textColor
        
        // CHANGE MESSAGE INPUT BAR STYLE
        messageInputBar.separatorLine.backgroundColor = textColor
        messageInputBar.inputTextView.layer.borderColor = textColor.cgColor
        
        // SEND TEXT
        messageInputBar.sendButton.setTitle(LocalizationKeys.ChatBot.send.localize(), for: .normal)
    }
    
    private func setUpNavigationBar() {
        let theme = ThemeManager.shared.currentTheme
        
        navigationItem.title = LocalizationKeys.ChatBot.chatBot.localize()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.themeBackground(for: theme)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white.themeText(for: theme), .font: UIFont.boldSystemFont(ofSize: 18)]
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let rightBarButton = UIBarButtonItem(title: LocalizationKeys.ChatBot.newSession.localize(), style: .plain, target: self, action: #selector(createNewSession))
        rightBarButton.tintColor = .link
        rightBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        messagesCollectionView.addGestureRecognizer(tap)
    }
    
    private func sendMessageToChatBot(_ text: String) {
        // user message
        let userMessage = Message(sender: currentUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        messages.append(userMessage)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
        addMessageToDb(message: userMessage, text: text)

        // ai message
        currentMessage = Message(sender: aiUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text("..."))
        messages.append(currentMessage!)
        messagesCollectionView.reloadData()

        chatBotService.sendMessage(message: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                updateCollectionViewWithAi(message: response.choices?.first?.message?.content ?? "")
            case .failure(_):
                self.messages.removeLast()
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
    private func updateCollectionViewWithAi(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let aiMessage = Message(sender: aiUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(message))
            messages[messages.count - 1] = aiMessage
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToLastItem(animated: true)
            
            addMessageToDb(message: aiMessage, text: message)
        }
    }
    
    private func setupLanguageObserver() {
        LocalizationManager.shared.$languageCode
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateLocalization()
            }.store(in: &cancellables)
    }
    
    // theme observer, will be triggered when user changes theme
    private func setupThemeObserver() {
        ThemeManager.shared.$theme
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateTheme()
            }.store(in: &cancellables)
    }
    
    
    // MARK: --objc functions
    @objc func dismissKeyboard() {
          view.endEditing(true)
    }
    
    @objc func createNewSession() {
        chatBotRepository.deleteSession(sessionId: sessionId)
        createSession()
        messages.removeAll()
        fetchMessages()

        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
}

// MARK: messages data source
extension ChatBotViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    var currentSender: SenderType {
        return currentUser
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar: Avatar
        if message.sender.senderId == currentUser.senderId {
            avatar = Avatar(image: userAvatar, initials: "US")
        } else {
            avatar = Avatar(image: AppImageConstants.chatBotImage, initials: "AI")
        }
        avatarView.set(avatar: avatar)
        avatarView.backgroundColor = .clear
    }
}

extension ChatBotViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let messageText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendMessageToChatBot(messageText)
        inputBar.inputTextView.text = ""
    }
}
