//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by BrottyS on 30.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IConversationListModel: class {
    weak var delegate: ConversationListModelDelegate? { get set }
    func getOnlineUsers()
}

protocol ConversationListModelDelegate: class {
    func setupDataSource(_ dataSource: [ConversationListViewModel])
}

class ConversationListModel: IConversationListModel {
    
    weak var delegate: ConversationListModelDelegate?
    
    private let communicatorService: ICommunicatorService
    
    init(communicatorService: ICommunicatorService) {
        self.communicatorService = communicatorService
    }
    
    func getOnlineUsers() {
        let onlineUsers = communicatorService.getOnlineUsers()
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

extension ConversationListModel: CommunicatorServiceDelegate {
    
    func didDataChange() {
        getOnlineUsers()
    }
    
}
