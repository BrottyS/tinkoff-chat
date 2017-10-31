//
//  ConversationListAssembly.swift
//  TinkoffChat
//
//  Created by BrottyS on 30.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

class ConversationListAssembly {

    func conversationListViewController() -> ConversationListViewController {
        let model = conversationListModel()
        let viewController = ConversationListViewController(model: model)
        model.delegate = viewController
        return viewController
    }

    // MARK: - Private section

    private func conversationListModel() -> IConversationListModel {
        let commService = communicatorService()
        let convListModel = ConversationListModel(communicatorService: commService)
        commService.delegate = convListModel
        return convListModel
    }

    private func communicatorService() -> ICommunicatorService {
        let comm = communicator()
        let commService = CommunicatorService(communicator: comm)
        comm.delegate = commService
        return commService
    }
    
    private func communicator() -> ICommunicator {
        return MultipeerCommunicator()
    }

}
