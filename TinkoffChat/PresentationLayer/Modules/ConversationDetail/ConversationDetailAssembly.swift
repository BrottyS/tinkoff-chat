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
    
    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    func conversationDetailViewController() -> ConversationDetailViewController {
        let model = conversationDetailModel()
        let viewController = ConversationDetailViewController(model: model)
        model.delegate = viewController
        return viewController
    }
    
    // MARK: - Private methods
    
    private func conversationDetailModel() -> IConversationDetailModel {
        let convDetailModel = ConversationDetailModel(communicationService: communicationService)
        communicationService.delegate = convDetailModel
        return convDetailModel
    }

}
