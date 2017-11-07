//
//  UserExtensions.swift
//  TinkoffChat
//
//  Created by BrottyS on 07.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import CoreData
import UIKit

extension User {
    
    static func findOrInsertUser(with userID: String, in context: NSManagedObjectContext) -> User? {
        if let user = User.insertUser(in: context) {
            user.userId = userID
            return user
        }
        
        return nil
    }
    
    static func insertUser(in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            return user
        }
        
        return nil
    }
    
    static func generateUserIdString() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func generateCurrentUserNameString() -> String {
        return "BrottyS"
    }
    
}
