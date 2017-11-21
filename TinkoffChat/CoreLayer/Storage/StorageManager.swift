//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by BrottyS on 07.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IStorageManager: class {
    func save(_ profile: ProfileModel, completion: @escaping (Bool) -> ())
    func read(completion: @escaping (ProfileModel?) -> ())
    
    func addOnlineUser(userID: String, userName: String?)
}

class StorageManager: IStorageManager {
    
    let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func save(_ profile: ProfileModel, completion: @escaping (Bool) -> ()) {
        
    }
    
    func read(completion: @escaping (ProfileModel?) -> ()) {
        
    }
    
    func addOnlineUser(userID: String, userName: String?) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            guard let conversation = Conversation.findOrInsertConversation(with: userID, in: saveContext) else { return }

        }
    }
    
}
