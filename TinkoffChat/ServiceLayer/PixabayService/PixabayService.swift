//
//  PixabayService.swift
//  TinkoffChat
//
//  Created by BrottyS on 21.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IPixabayService: class {
    func loadImageHits(completionHandler: @escaping ([PixabayApiModel]?, String?) -> Void)
}

class PixabayService: IPixabayService {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    // MARK: - IPixabayService
    
    func loadImageHits(completionHandler: @escaping ([PixabayApiModel]?, String?) -> Void) {
        let requestConfig = RequestsFactory.PixabayRequests.imageHitsConfig()
        
        requestSender.send(config: requestConfig) { (result: Result<[PixabayApiModel]>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
