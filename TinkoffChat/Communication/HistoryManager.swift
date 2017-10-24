//
//  HistoryManager.swift
//  TinkoffChat
//
//  Created by BrottyS on 23.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

class HistoryManager {
    
    static let `default` = HistoryManager()
    
    private var messages: [History] = []
    
    func add(_ history: History) {
        messages.append(history)
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
