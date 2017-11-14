//
//  ProfileService.swift
//  TinkoffChat
//
//  Created by BrottyS on 12.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IProfileService: class {
    func read()
    func save()
}

class ProfileService: IProfileService {
    
    private let storageManager: IStorageManager
    
    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    func read() {
        
    }
    
    func save() {
        
    }
    
}
