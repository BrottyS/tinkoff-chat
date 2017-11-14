//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IRootAssembly: class {
    var conversationListAssembly: IConversationListAssembly { get set }
    //var conversationDetailAssembly: IConversationDetailAssembly { get set }
    //var profileAssembly: IProfileAssembly { get set }
}

class RootAssembly: IRootAssembly {
    
    private let communicationService: ICommunicationService = {
        let messageSerializer: IMessageSerializer = MessageSerializer()
        let communicator: ICommunicator = MultipeerCommunicator(messageSerializer: messageSerializer)
        let commService = CommunicationService(communicator: communicator)
        communicator.delegate = commService
        return commService
    }()
    
    var conversationListAssembly: IConversationListAssembly
    
    init() {
        //let commService = communicationService()
        conversationListAssembly = ConversationListAssembly(communicationService: communicationService)
    }
    
    // MARK: - Private methods
    
    /*
    private func communicationService() -> ICommunicationService {
        let comm = communicator()
        let commService = CommunicationService(communicator: comm)
        comm.delegate = commService
        return commService
    }
    
    private func communicator() -> ICommunicator {
        let msgSerializer = messageSerializer()
        return MultipeerCommunicator(messageSerializer: msgSerializer)
    }
    
    private func messageSerializer() -> IMessageSerializer {
        return MessageSerializer()
    }*/
    
}
