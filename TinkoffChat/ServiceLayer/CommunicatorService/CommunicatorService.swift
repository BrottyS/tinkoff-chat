//
//  CommunicatorService.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

protocol ICommunicatorService: class {
    weak var delegate: CommunicatorServiceDelegate? { get set }
    func getOnlineUsers() -> [UserServiceModel]
    func sendMessage(_ text: String, to: String)
}

protocol CommunicatorServiceDelegate: class {
    func didDataChange()
}

class CommunicatorService: ICommunicatorService {
    
    weak var delegate: CommunicatorServiceDelegate?
    
    private let communicator: ICommunicator
    
    private var onlineUsers: [UserServiceModel] = []
    
    init(communicator: ICommunicator) {
        self.communicator = communicator
    }
    
    // MARK: - ICommunicatorService
    
    func getOnlineUsers() -> [UserServiceModel] {
        return onlineUsers
    }
    
    func sendMessage(_ text: String, to: String) {
        // prepare message to send
        let message = Message(eventType: "TextMessage",
                              messageId: generateMessageId(),
                              text: text)
        let messageData = try! JSONEncoder().encode(message)
        let messageJson = String(data: messageData, encoding: .utf8)!
        
        communicator.sendMessage(string: messageJson, to: to) { (success, error) in
            // if the message sent successfully, add it to history
            if success {
                let history = History(date: self.extractDate(from: message.messageId!),
                                      from: self.communicator.localPeerDisplayName(),
                                      to: to,
                                      message: MessageModel(text: text, incoming: false))
                HistoryManager.default.add(history)
                self.delegate?.didDataChange()
            }
            
            if let error = error {
                print("Error while send message: \(error.localizedDescription)")
            }
        }
    }
    
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    private func extractDate(from messageId: String) -> Date {
        let decodedData = Data(base64Encoded: messageId)!
        let decodedStr = String(data: decodedData, encoding: .utf8)!
        let splittedStr = decodedStr.split(separator: "+")
        let timeInterval = Double(splittedStr[1])!
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
    
}

extension CommunicatorService: MultipeerCommunicatorDelegate {
        
    func didFoundUser(userID: String, userName: String?) {
        print("Found user with userID: \(userID), userName: \(userName ?? "?")")
        if !onlineUsers.contains(where: { $0.userID == userID }) {
            onlineUsers.append(UserServiceModel(userID: userID, userName: userName))
        }
        delegate?.didDataChange()
    }
    
    func didLostUser(userID: String) {
        print("Lost user with userID: \(userID)")
        if let index = onlineUsers.index(where: { $0.userID == userID }) {
            onlineUsers.remove(at: index)
            delegate?.didDataChange()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("Failed to start browsing with error: \(error.localizedDescription)")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("Failed to start advertising with error: \(error.localizedDescription)")
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        print("Received message: \"\(text)\" from user: \(fromUser)")
        
        // decode message
        let messageData = text.data(using: .utf8)!
        let message = try! JSONDecoder().decode(Message.self, from: messageData)
        
        // add received message to history
        let history = History(date: extractDate(from: message.messageId!),
                              from: fromUser,
                              to: toUser,
                              message: MessageModel(text: message.text, incoming: true))
        HistoryManager.default.add(history)
        
        delegate?.didDataChange()
    }
    
    func didChangeUserStatus(userID: String, online: Bool) {
        
    }
    
}
