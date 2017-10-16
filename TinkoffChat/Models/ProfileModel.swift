//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by BrottyS on 16.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

class ProfileModel {
    
    private let kNameKey = "name"
    private let kAboutMeKey = "about_me"
    private let kAvatarKey = "avatar"
    
    var name: String?
    var aboutMe: String?
    var avatarImageData: NSData?
    
    init() {
        
    }
    
    init(name: String?, aboutMe: String?, avatarImageData: NSData?) {
        self.name = name
        self.aboutMe = aboutMe
        self.avatarImageData = avatarImageData
    }
    
    init(dict: NSDictionary) {
        name = dict.object(forKey: kNameKey) as? String
        aboutMe = dict.object(forKey: kAboutMeKey) as? String
        avatarImageData = dict.object(forKey: kAvatarKey) as? NSData
    }
    
    func toDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict[kNameKey] = name
        dict[kAboutMeKey] = aboutMe
        dict[kAvatarKey] = avatarImageData
        return dict
    }
    
}

extension ProfileModel: Equatable {
    
    static func == (lhs: ProfileModel, rhs: ProfileModel) -> Bool {
        if lhs.name != rhs.name { return false }
        if lhs.aboutMe != rhs.aboutMe { return false }
        if lhs.avatarImageData == nil && rhs.avatarImageData == nil { return true }
        guard let lData = lhs.avatarImageData, let rData = rhs.avatarImageData else { return false }
        return lData.isEqual(to: rData as Data)
    }
    
}
