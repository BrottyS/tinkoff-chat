//
//  ConversationDetailModel.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IConversationDetailModel: class {
    weak var delegate: ConversationDetailModelDelegate? { get set }
    func getOnlineUsers()
}

protocol ConversationDetailModelDelegate: class {
    func setupDataSource(_ dataSource: [ConversationDetailViewModel])
}

class ConversationDetailModel: IConversationDetailModel {
    
    weak var delegate: ConversationDetailModelDelegate?
    
    private let communicatorService: ICommunicationService
    
    init(communicatorService: ICommunicationService) {
        self.communicatorService = communicatorService
    }
    
    func getOnlineUsers() {
        
    }
    
    /*
    func getOnlineUsers() {
        let onlineUsers = communicatorService.getOnlineUsers()
        var cells: [ConversationListViewModel] = []
        for user in onlineUsers {
            let lastMessage = HistoryManager.default.lastMessageFor(userID: user.userID)
            let cell = ConversationDetailViewModel(name: user.userName,
                                                 message: lastMessage?.message.text,
                                                 date: lastMessage?.date,
                                                 online: true,
                                                 hasUnreadMessages: false)
            cells.append(cell)
        }
        delegate?.setupDataSource(cells)
    }*/
    
}
