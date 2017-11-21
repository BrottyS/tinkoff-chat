//
//  ImageSelectorInteractor.swift
//  TinkoffChat
//
//  Created by BrottyS on 21.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IImageSelectorInteractor: class {
    weak var delegate: IImageSelectorInteractorDelegate? { get set }
    func fetchImageHits()
}

protocol IImageSelectorInteractorDelegate: class {
    func setup(dataSource: [PixabayDisplayModel])
    func show(error message: String)
}

struct PixabayDisplayModel {
    let previewUrl: String?
    //let imageUrl: String?
}

class ImageSelectorInteractor: IImageSelectorInteractor {
    
    weak var delegate: IImageSelectorInteractorDelegate?
    
    private let pixabayService: IPixabayService
    
    init(pixabayService: IPixabayService) {
        self.pixabayService = pixabayService
    }
    
    // MARK: - IImageSelectorInteractor
    
    func fetchImageHits() {
        pixabayService.loadImageHits { (images: [PixabayApiModel]?, errorMessage) in
            if let images = images {
                let cells = images.map({ PixabayDisplayModel(previewUrl: $0.previewURL) })
                self.delegate?.setup(dataSource: cells)
            } else {
                self.delegate?.show(error: errorMessage ?? "Error")
            }
        }
    }
    
}
