//
//  ConversationDetailViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

private let kIncomingMessageCellId = "IncomingMessageCell"
private let kOutgoingMessageCellId = "OutgoingMessageCell"

class ConversationDetailViewController: UIViewController, ConversationDetailModelDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Private properties
    
    private var dataSource: [ConversationDetailViewModel] = []
    private let model: IConversationDetailModel
    
    init(model: IConversationDetailModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        // TODO: something like model.requestForUpdates()
        model.getOnlineUsers()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IncomingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: kIncomingMessageCellId)
        tableView.register(UINib(nibName: "OutgoingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: kOutgoingMessageCellId)
    }
    
    // MARK: - ConversationDetailModelDelegate
    
    func setupDataSource(_ dataSource: [ConversationDetailViewModel]) {
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = dataSource[indexPath.row]
        
        let identifier = message.incoming ? kIncomingMessageCellId : kOutgoingMessageCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageTableViewCell
        cell.configure(with: message)
        
        return cell
    }

}
