//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by BrottyS on 07.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IProfileAssembly: class {
    func profileViewController() -> ProfileViewController
}

class ProfileAssembly: IProfileAssembly {
    
    func profileViewController() -> ProfileViewController {
        let model = profileInteractor()
        return ProfileViewController(model: model)
    }
    
    // MARK: - Private section
    
    private func profileInteractor() -> IProfileInteractor {
        let storageServ = storageService()
        return ProfileInteractor(storageService: storageServ)
    }
    
    private func storageService() -> IStorageService {
        let coreDS = coreDataStack()
        let storageManager = StorageManager(coreDataStack: coreDS)
        return StorageService(storageManager: storageManager)
    }
    
    private func coreDataStack() -> ICoreDataStack {
        return CoreDataStack()
    }
    
}
