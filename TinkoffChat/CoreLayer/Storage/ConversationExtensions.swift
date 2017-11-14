//
//  ConversationExtensions.swift
//  TinkoffChat
//
//  Created by BrottyS on 13.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import CoreData

extension Conversation {

    static func findOrInsertConversation(with id: String, in context: NSManagedObjectContext) -> Conversation? {
        if let conversation = fetchConversation(with: id, in: context) {
            return conversation
        } else {
            return Conversation.insertConversation(with: id, in: context)
        }
    }
    
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
    }
    
    static func fetchRequestConversation(with id: String, model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        let templateName = "ConversationWithId"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["conversationId": id]) as? NSFetchRequest<Conversation> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
    
        return fetchRequest
    }
    
    static func insertConversation(with id: String, in context: NSManagedObjectContext) -> Conversation? {
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
            conversation.conversationId = id
            return conversation
        }
        
        return nil
    }

}
