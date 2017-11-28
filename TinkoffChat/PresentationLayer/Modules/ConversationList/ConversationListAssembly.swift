//
//  ConversationListAssembly.swift
//  TinkoffChat
//
//  Created by BrottyS on 30.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

protocol IConversationListAssembly: class {
    func conversationListViewController() -> ConversationListViewController
    func presentConversationDetailViewController(from vc: ConversationListViewController, for userID: String)
    func presentProfileViewController(from vc: ConversationListViewController)
}

class ConversationListAssembly: IConversationListAssembly {
    
    private let communicationService: ICommunicationService
    
    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    func conversationListViewController() -> ConversationListViewController {
        let model = conversationListModel()
        let viewController = ConversationListViewController(model: model)
        viewController.assembly = self
        model.delegate = viewController
        return viewController
    }
    
    func presentConversationDetailViewController(from vc: ConversationListViewController, for userID: String) {
        let conversationDetailAssembly: IConversationDetailAssembly = ConversationDetailAssembly(communicationService: communicationService, userID: userID)
        let conversationDetailVC = conversationDetailAssembly.conversationDetailViewController()
        vc.navigationController?.pushViewController(conversationDetailVC, animated: true)
    }
    
    func presentProfileViewController(from vc: ConversationListViewController) {
        let profileVC = ProfileAssembly().profileViewController()
        let profileNC = UINavigationController(rootViewController: profileVC)
        vc.present(profileNC, animated: true, completion: nil)
    }

    // MARK: - Private section

    private func conversationListModel() -> IConversationListModel {
        let commService = communicationService
        let histService = historyService()
        
        let convListModel = ConversationListModel(communicationService: commService,
                                                  historyService: histService)
        
        //commService.delegate = convListModel
        //convListModel.setupCommunicationServiceDelegate()
        histService.delegate = convListModel
        
        return convListModel
    }

    /*
    private func communicationService() -> ICommunicationService {
        let comm = communicator()
        let commService = CommunicationService(communicator: comm)
        comm.delegate = commService
        return commService
    }*/
    
    private func historyService() -> IHistoryService {
        let histStorage = historyStorage()
        let histService = HistoryService(historyStorage: histStorage)
        histStorage.delegate = histService
        return histService
    }
    
    /*
    private func communicator() -> ICommunicator {
        let serializer = messageSerializer()
        return MultipeerCommunicator(messageSerializer: serializer)
    }*/
    
    /*
    private func messageSerializer() -> IMessageSerializer {
        return MessageSerializer()
    }*/
    
    private func historyStorage() -> IHistoryStorage {
        return HistoryStorage()
    }

}
