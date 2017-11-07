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
            let cell = ConversationListViewModel(name: user.userName,
                                                 message: lastMessage?.message.text,
                                                 date: lastMessage?.date,
                                                 online: true,
                                                 hasUnreadMessages: false)
            cells.append(cell)
        }
        delegate?.setupDataSource(cells)
    }
    
}

extension ConversationListModel: ICommunicationServiceDelegate {
    
    func didDataChange() {
        getOnlineUsers()
    }
    
}

extension ConversationListModel: IHistoryServiceDelegate {
    
    func didAddHistory() {
        
    }
    
}
