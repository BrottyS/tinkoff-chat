//
//  CommunicationService.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

protocol ICommunicationService: class {
    weak var delegate: ICommunicationServiceDelegate? { get set }
    func getOnlineUsers() -> [UserServiceModel]
    func sendMessage(_ text: String, to: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
}

protocol ICommunicationServiceDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    
    func didDataChange()
    //func didSendMessage()
}

class CommunicationService: ICommunicationService {
    
    weak var delegate: ICommunicationServiceDelegate?
    
    private let communicator: ICommunicator
    
    init(communicator: ICommunicator) {
        self.communicator = communicator
    }
    
    // MARK: - ICommunicationService
    
    func getOnlineUsers() -> [UserServiceModel] {
        return communicator.getOnlineUsers()
    }
    
    func sendMessage(_ text: String, to: String, completionHandler: ((Bool, Error?) -> ())?) {
        communicator.sendMessage(string: text, to: to, completionHandler: completionHandler)
        
        /*
        { (success, error) in
            // if the message sent successfully, add it to history
            if success {
                /*
                let history = History(date: self.extractDate(from: message.messageId!),
                                      from: self.communicator.localPeerDisplayName(),
                                      to: to,
                                      message: MessageModel(text: text, incoming: false))
                HistoryManager.default.add(history)*/
                self.delegate?.didDataChange()
            }
            
            if let error = error {
                print("Error while send message: \(error.localizedDescription)")
            }
        }*/
    }

}

extension CommunicationService: MultipeerCommunicatorDelegate {
        
    func didFoundUser(userID: String, userName: String?) {
        print("Found user with userID: \(userID), userName: \(userName ?? "?")")
        //delegate?.didDataChange()
        delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        print("Lost user with userID: \(userID)")
        //delegate?.didDataChange()
        delegate?.didLostUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("Failed to start browsing with error: \(error.localizedDescription)")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("Failed to start advertising with error: \(error.localizedDescription)")
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        print("Received message: \"\(text)\" from user: \(fromUser)")
        
        
        
        // add received message to history
        /*
        let history = History(date: extractDate(from: message.messageId!),
                              from: fromUser,
                              to: toUser,
                              message: MessageModel(text: message.text, incoming: true))
        HistoryManager.default.add(history)*/
        
        delegate?.didDataChange()
    }
    
    func didChangeUserStatus(userID: String, online: Bool) {
        
    }
    
}
