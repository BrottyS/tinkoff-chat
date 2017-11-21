//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

protocol IRequestSender: class {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}

/* OLD
struct RequestConfig<T> {
    let request: IRequest
    let parser: Parser<T>
}*/

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

enum Result<T> {
    case success(T)
    case error(String)
}

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            
            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(Result.error("received data can't be parsed"))
                    return
            }
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
}

