//
//  HistoryStorage.swift
//  TinkoffChat
//
//  Created by BrottyS on 06.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IHistoryStorage: class {
    weak var delegate: IHistoryStorageDelegate? { get set }
    func add(_ history: History)
    func lastMessageFor(userID: String) -> History?
    func historyFor(userID: String) -> [MessageModel]
}

protocol IHistoryStorageDelegate: class {
    func didAddHistory()
}

class HistoryStorage: IHistoryStorage {
    
    weak var delegate: IHistoryStorageDelegate?
    
    private var messages: [History] = []
    
    func add(_ history: History) {
        messages.append(history)
        delegate?.didAddHistory()
    }
    
    func lastMessageFor(userID: String) -> History? {
        var conversations = messages.filter { history in
            history.from == userID || history.to == userID
        }
        
        conversations = conversations.sorted { left, right in
            left.date > right.date
        }
        
        return conversations.count > 0 ? conversations[0] : nil
    }
    
    func historyFor(userID: String) -> [MessageModel] {
        var conversations = messages.filter { history in
            history.from == userID || history.to == userID
        }
        
        conversations = conversations.sorted { left, right in
            left.date < right.date
        }
        
        var res: [MessageModel] = []
        for conversation in conversations {
            res.append(conversation.message)
        }
        return res
    }
    
}
