//
//  StorageService.swift
//  TinkoffChat
//
//  Created by BrottyS on 07.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IStorageService: class {
    func save(_ profile: ProfileModel, completion: @escaping (Bool) -> ())
    func read(completion: @escaping (ProfileModel?) -> ())
}

class StorageService: IStorageService {
    
    let storageManager: IStorageManager
    
    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    func save(_ profile: ProfileModel, completion: @escaping (Bool) -> ()) {
        storageManager.save(profile, completion: completion)
    }
    
    func read(completion: @escaping (ProfileModel?) -> ()) {
        storageManager.read(completion: completion)
    }
    
}
