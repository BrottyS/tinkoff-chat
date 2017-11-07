//
//  MessageSerializer.swift
//  TinkoffChat
//
//  Created by BrottyS on 06.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

protocol IMessageSerializer: class {
    func serialize(text: String) -> Data?
    func deserialize(data: Data) -> String?
}

class MessageSerializer: IMessageSerializer {
    
    func serialize(text: String) -> Data? {
        let message = Message(eventType: "TextMessage",
                              messageId: generateMessageId(),
                              text: text)
        do {
            let messageData = try JSONEncoder().encode(message)
            //let messageJson = String(data: messageData, encoding: .utf8)
            //return messageJson?.data(using: .utf8)
            return messageData
        } catch {
            print("Error while message serialization. \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func deserialize(data: Data) -> String? {
        //let message = String(data: data, encoding: .utf8)
        //let messageData = message?.data(using: .utf8)
        do {
            let message = try JSONDecoder().decode(Message.self, from: data)
            return message.text
        } catch {
            print("Error while message deserialization. \(error.localizedDescription)")
        }
        
        return nil
    }
    
    // MARK: - Private methods
    
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    private func extractDate(from messageId: String) -> Date {
        let decodedData = Data(base64Encoded: messageId)!
        let decodedStr = String(data: decodedData, encoding: .utf8)!
        let splittedStr = decodedStr.split(separator: "+")
        let timeInterval = Double(splittedStr[1])!
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
    
}
