//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by BrottyS on 16.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

enum Result {
    case success
    case failure
}

protocol DataManagerProtocol {
    
    func save(_ profile: ProfileModel, completion: @escaping (Result) -> ())
    func read(completion: @escaping (ProfileModel?) -> ())
    
}
