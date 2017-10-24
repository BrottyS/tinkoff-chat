//
//  CommunicatorProtocol.swift
//  TinkoffChat
//
//  Created by BrottyS on 21.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: CommunicatorDelegate? { get set }
    var online: Bool { get set }
}

protocol CommunicatorDelegate: class {
    // discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    // messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    
    // status
    func didChangeUserStatus(userID: String, online: Bool)
}
