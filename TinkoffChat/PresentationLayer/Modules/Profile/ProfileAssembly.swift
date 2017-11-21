//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by BrottyS on 07.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

protocol IProfileAssembly: class {
    func profileViewController() -> ProfileViewController
    func presentImageSelectorViewController(from vc: ProfileViewController)
}

class ProfileAssembly: IProfileAssembly {
    
    func profileViewController() -> ProfileViewController {
        let model = profileInteractor()
        let profileVC = ProfileViewController(model: model)
        profileVC.assembly = self
        return profileVC
    }
    
    func presentImageSelectorViewController(from vc: ProfileViewController) {
        let imageSelectorVC = ImageSelectorAssembly().imageSelectorViewController()
        let imageSelectorNC = UINavigationController(rootViewController: imageSelectorVC)
        vc.present(imageSelectorNC, animated: true, completion: nil)
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
