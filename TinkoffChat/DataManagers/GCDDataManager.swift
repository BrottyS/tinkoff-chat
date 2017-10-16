//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by BrottyS on 15.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

class GCDDataManager: DataManagerProtocol {
    
    private var fileName: String
    
    init(fileName: String) {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.fileName = (dir as NSString).appendingPathComponent(fileName)
    }
    
    func save(_ profile: ProfileModel, completion: @escaping (Result) -> ()) {
        let dict = profile.toDictionary()
        DispatchQueue.global(qos: .utility).async {
            let res = dict.write(toFile: self.fileName, atomically: false)
            DispatchQueue.main.async {
                completion(res == true ? .success : .failure)
            }
        }
    }
    
    func read(completion: @escaping (ProfileModel?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            if let dict = NSDictionary(contentsOfFile: self.fileName) {
                let profile = ProfileModel(dict: dict)
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}
