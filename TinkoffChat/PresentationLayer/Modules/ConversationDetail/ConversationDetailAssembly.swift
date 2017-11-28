//
//  ConversationDetailAssembly.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IConversationDetailAssembly: class {
    func conversationDetailViewController() -> ConversationDetailViewController
}

class ConversationDetailAssembly: IConversationDetailAssembly {
    
    private let communicationService: ICommunicationService
    private let userID: String
    
    init(communicationService: ICommunicationService, userID: String) {
        self.communicationService = communicationService
        self.userID = userID
    }
    
    func conversationDetailViewController() -> ConversationDetailViewController {
        let model = conversationDetailModel()
        let viewController = ConversationDetailViewController(model: model)
        model.delegate = viewController
        return viewController
    }
    
    // MARK: - Private methods
    
    private func conversationDetailModel() -> IConversationDetailModel {
        let convDetailModel = ConversationDetailModel(communicationService: communicationService, userID: userID)
        communicationService.delegate = convDetailModel
        return convDetailModel
    }

}
