//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by BrottyS on 08.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, MessageCellConfiguration {

    // MARK: - IBOutlets
    
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - MessageCellConfiguration
    
    var messageText: String? {
        didSet {
            messageLabel.text = messageText
        }
    }

}
