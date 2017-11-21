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
        return ImageSelectorViewController()
    }
    
}
