//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by BrottyS on 30.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IConversationListModel: class {
    weak var delegate: IConversationListModelDelegate? { get set }
    func getOnlineUsers()
    
    func setupCommunicationServiceDelegate()
}

protocol IConversationListModelDelegate: class {
    func setupDataSource(_ dataSource: [ConversationListViewModel])
}

class ConversationListModel: IConversationListModel {
    
    weak var delegate: IConversationListModelDelegate?
    
    private let communicationService: ICommunicationService
    private let historyService: IHistoryService
    
    init(communicationService: ICommunicationService,
         historyService: IHistoryService) {
        self.communicationService = communicationService
        self.historyService = historyService
    }
    
    func getOnlineUsers() {
        let onlineUsers = communicationService.getOnlineUsers()
        var cells: [ConversationListViewModel] = []
        for user in onlineUsers {
            let lastMessage = HistoryManager.default.lastMessageFor(userID: user.userID)
            let cell = ConversationListViewModel(userID: user.userID,
                                                 name: user.userName,
                                                 message: lastMessage?.message.text,
                                                 date: lastMessage?.date,
                                                 online: true,
                                                 hasUnreadMessages: false)
            cells.append(cell)
        }
        delegate?.setupDataSource(cells)
    }
    
    func setupCommunicationServiceDelegate() {
        communicationService.delegate = self
    }
    
}

extension ConversationListModel: ICommunicationServiceDelegate {
    
    func didFoundUser(userID: String, userName: String?) {
        getOnlineUsers()
    }
    
    func didLostUser(userID: String) {
        getOnlineUsers()
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
    }
    
    func didDataChange() {
        getOnlineUsers()
    }
    
}

extension ConversationListModel: IHistoryServiceDelegate {
    
    func didAddHistory() {
        
    }
    
}
