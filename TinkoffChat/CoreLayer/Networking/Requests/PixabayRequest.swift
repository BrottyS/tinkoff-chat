//
//  PixabayRequest.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

// https://pixabay.com/api/?key=7124343-8e8f42368bfadeb2d425dd3ec&q=yellow+flowers&image_type=photo&pretty=true&per_page=100

class PixabayRequest: IRequest {
    private let baseUrl = "https://pixabay.com/api/"
    private let apiKey: String
    private var getParameters: [String: String]  {
        return ["key": apiKey,
                "q": "yellow+flowers",
                "image_type": "photo",
                "pretty": "true",
                "per_page": "100"]
    }
    private var urlString: String {
        let getParams = getParameters.flatMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
}
