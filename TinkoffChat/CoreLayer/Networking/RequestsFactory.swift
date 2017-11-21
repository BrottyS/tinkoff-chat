//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by BrottyS on 21.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

struct RequestsFactory {
    
    struct PixabayRequests {
        
        static func imageHitsConfig() -> RequestConfig<PixabayParser> {
            let request = PixabayRequest(apiKey: "7124343-8e8f42368bfadeb2d425dd3ec")
            return RequestConfig<PixabayParser>(request: request, parser: PixabayParser())
        }
        
    }

}
