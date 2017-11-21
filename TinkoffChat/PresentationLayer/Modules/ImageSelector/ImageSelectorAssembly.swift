//
//  ImageSelectorAssembly.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IImageSelectorAssembly: class {
    func imageSelectorViewController() -> ImageSelectorViewController
}

class ImageSelectorAssembly: IImageSelectorAssembly {

    func imageSelectorViewController() -> ImageSelectorViewController {
        let interactor = imageSelectorInteractor()
        let imageSelectorVC = ImageSelectorViewController(interactor: interactor)
        interactor.delegate = imageSelectorVC
        return imageSelectorVC
    }
    
    // MARK: - Private methods
    
    private func imageSelectorInteractor() -> IImageSelectorInteractor {
        return ImageSelectorInteractor(pixabayService: pixabayService())
    }
    
    private func pixabayService() -> IPixabayService {
        return PixabayService(requestSender: requestSender())
    }
    
    private func requestSender() -> IRequestSender {
        return RequestSender()
    }
    
}
