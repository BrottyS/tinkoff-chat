//
//  MessageTableViewCell.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, IConversationDetailTableViewCellConfiguration {

    // MARK: - IBOutlets
    
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Private properties
    
    private var message: ConversationDetailViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - IConversationDetailTableViewCellConfiguration
    
    func configure(with message: ConversationDetailViewModel) {
        self.message = message
        
        messageLabel.text = self.message?.text
    }
    
}
