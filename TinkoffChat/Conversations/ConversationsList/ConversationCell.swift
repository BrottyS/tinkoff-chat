//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by BrottyS on 08.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Private constants
    
    private let regularMessageFont = UIFont.systemFont(ofSize: 13)
    private let noMessagesYetFont = UIFont.italicSystemFont(ofSize: 13)
    private let hasUnreadMessageFont = UIFont.boldSystemFont(ofSize: 13)
    
    private let lightYellow = UIColor(red: 255.0 / 255.0,
                                      green: 254.0 / 255.0,
                                      blue: 209.0 / 255.0,
                                      alpha: 1.0)
    
    // MARK: - ConversationCellConfiguration
    
    var name: String? {
        didSet {
            nameLabel.text = name != nil ? name : "Unknown"
        }
    }
    
    var message: String? {
        didSet {
            configureMessageLabelFont()
            messageLabel.text = message == nil ? "No messages yet." : message
        }
    }
    
    var date: Date? {
        didSet {
            dateLabel.text = formattedDate(date)
        }
    }
    
    var online: Bool = false {
        didSet {
            backgroundColor = online ? lightYellow : .white
        }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            configureMessageLabelFont()
        }
    }
    
    private func configureMessageLabelFont() {
        if message == nil {
            messageLabel.font = noMessagesYetFont
        } else {
            messageLabel.font = hasUnreadMessages ? hasUnreadMessageFont : regularMessageFont
        }
    }
    
    // MARK: - Utils
    
    private func formattedDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM"
        }
        
        return dateFormatter.string(from: date)
    }
    
}
