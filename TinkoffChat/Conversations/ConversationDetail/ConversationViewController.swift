//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 08.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private constants
    
    private let incomingMessageCellId = "IncomingMessageCell"
    private let outgoingMessageCellId = "OutgoingMessageCell"
    
    private let data = [MessageModel(text: "А", incoming: true),
                        MessageModel(text: "Б", incoming: false),
                        MessageModel(text: "Сообщение длиной  30 символов", incoming: true),
                        MessageModel(text: "Сообщение длиной  30 символов", incoming: false),
                        MessageModel(text: "А это сообщение длиной аж 300 символов. Оно нужно для того чтобы проверить, насколько правильно ячейки отображают длинный текст, такой, как этот. Этот текст очень длинный, надо чем-то его заполнить до трехсот символов. Осталось еще немного, и цель будет достигнута. Триста символов, е-мое. Finally!!", incoming: true),
                        MessageModel(text: "А это сообщение длиной аж 300 символов. Оно нужно для того чтобы проверить, насколько правильно ячейки отображают длинный текст, такой, как этот. Этот текст очень длинный, надо чем-то его заполнить до трехсот символов. Осталось еще немного, и цель будет достигнута. Триста символов, е-мое. Finally!!", incoming: false),]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageCell
        
        let message = data[indexPath.row]
        
        let identifier = message.incoming ? incomingMessageCellId : outgoingMessageCellId
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell {
            cell = dequeuedCell
        } else {
            cell = MessageCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell.messageText = message.text
        
        return cell
    }

}
