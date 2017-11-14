//
//  MessageExtensions.swift
//  TinkoffChat
//
//  Created by BrottyS on 13.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import CoreData

extension Message {
    
    /*
    static func fetchConversation(with id: String, in context: NSManagedObjectContext) -> Conversation? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        
        guard let fetchRequest = Conversation.fetchRequestConversation(with: id, model: model) else { return nil }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Conversations found with id: \(id)")
            return results.first
        } catch {
            print("Failed to fetch Conversation with id: \(id) \(error)")
            return nil
        }
    }*/
    
    static func fetchRequestMessage(with conversationId: String, model: NSManagedObjectModel) -> NSFetchRequest<Message>? {
        let templateName = "MessagesInConversation"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["conversationId": conversationId]) as? NSFetchRequest<Message> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        
        return fetchRequest
    }
    
    /*
    static func insertMessage(with id: String, in context: NSManagedObjectContext) -> Message? {
        if let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message {
            message.id = id
            return conversation
        }
        
        return nil
    }*/
    
}
