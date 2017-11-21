//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by BrottyS on 16.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol DataManagerProtocol {
    func save(_ profile: ProfileModel, completion: @escaping (Bool) -> ())
    func read(completion: @escaping (ProfileModel?) -> ())
}
