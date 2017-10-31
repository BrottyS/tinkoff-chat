//
//  IConversationListTableViewCellConfiguration.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IConversationListTableViewCellConfiguration: class {
    func configure(with: ConversationListViewModel)
}
