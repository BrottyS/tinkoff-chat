//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by BrottyS on 07.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IProfileInteractor: class {
    
}

class ProfileInteractor: IProfileInteractor {
    
    private let storageService: IStorageService
    
    init(storageService: IStorageService) {
        self.storageService = storageService
    }
    
}
