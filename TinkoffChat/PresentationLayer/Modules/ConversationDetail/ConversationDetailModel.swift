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
    
    func setupCommunicationServiceDelegate()
}

protocol ConversationDetailModelDelegate: class {
    func setupDataSource(_ dataSource: [ConversationDetailViewModel])
    
    func userBecomeOnline()
    func userBecomeOffline()
}

class ConversationDetailModel: IConversationDetailModel {
    
    weak var delegate: ConversationDetailModelDelegate?
    
    private let communicationService: ICommunicationService
    private let userID: String
    
    init(communicationService: ICommunicationService, userID: String) {
        self.communicationService = communicationService
        self.userID = userID
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
    
    func setupCommunicationServiceDelegate() {
        communicationService.delegate = self
    }
    
}

extension ConversationDetailModel: ICommunicationServiceDelegate {
    
    func didFoundUser(userID: String, userName: String?) {
        if userID == self.userID {
            delegate?.userBecomeOnline()
        }
    }
    
    func didLostUser(userID: String) {
        if userID == self.userID {
            delegate?.userBecomeOffline()
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
    }
    
    func didDataChange() {
        
    }
    
}
