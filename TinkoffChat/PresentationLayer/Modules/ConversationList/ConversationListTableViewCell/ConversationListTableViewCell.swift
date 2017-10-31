//
//  ConversationListTableViewCell.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell, IConversationListTableViewCellConfiguration {

    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Private properties
    
    private let regularMessageFont = UIFont.systemFont(ofSize: 13)
    private let noMessagesYetFont = UIFont.italicSystemFont(ofSize: 13)
    private let hasUnreadMessageFont = UIFont.boldSystemFont(ofSize: 13)
    
    private let lightYellow = UIColor(red: 255.0 / 255.0,
                                      green: 254.0 / 255.0,
                                      blue: 209.0 / 255.0,
                                      alpha: 1.0)
    
    private var conversation: ConversationListViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - IConversationListTableViewCellConfiguration
    
    func configure(with conversationVM: ConversationListViewModel) {
        self.conversation = conversationVM
        
        guard let conversation = self.conversation else { return }
        // maybe better let conversation = self.conversation!
        
        // name
        nameLabel.text = conversation.name != nil ? conversation.name : "Unknown"
        
        // date
        dateLabel.text = formattedDate(conversation.date)
        
        // message
        messageLabel.text = conversation.message == nil ? "No messages yet." : conversation.message
        
        // online/offline
        backgroundColor = conversation.online ? lightYellow : .white
        
        // configure messageLabel font
        if conversation.message == nil {
            messageLabel.font = noMessagesYetFont
        } else {
            messageLabel.font = conversation.hasUnreadMessages ? hasUnreadMessageFont : regularMessageFont
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
