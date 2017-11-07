//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by BrottyS on 07.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IStorageManager: class {
    func save(_ profile: ProfileModel, completion: @escaping (Result) -> ())
    func read(completion: @escaping (ProfileModel?) -> ())
}

class StorageManager: IStorageManager {
    
    let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func save(_ profile: ProfileModel, completion: @escaping (Result) -> ()) {
        
    }
    
    func read(completion: @escaping (ProfileModel?) -> ()) {
        
    }
    
}
