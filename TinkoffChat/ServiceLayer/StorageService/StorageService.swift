//
//  StorageService.swift
//  TinkoffChat
//
//  Created by BrottyS on 07.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

enum Result {
    case success
    case failure
}

protocol IStorageService: class {
    func save(_ profile: ProfileModel, completion: @escaping (Result) -> ())
    func read(completion: @escaping (ProfileModel?) -> ())
}

class StorageService: IStorageService {
    
    let storageManager: IStorageManager
    
    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    func save(_ profile: ProfileModel, completion: @escaping (Result) -> ()) {
        storageManager.save(profile, completion: completion)
    }
    
    func read(completion: @escaping (ProfileModel?) -> ()) {
        storageManager.read(completion: completion)
    }
    
}
