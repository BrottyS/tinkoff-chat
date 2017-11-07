//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 08.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDataSource {
    
    var user: User?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Private constants
    
    private let incomingMessageCellId = "IncomingMessageCell"
    private let outgoingMessageCellId = "OutgoingMessageCell"
    
    private var data: [MessageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //CommunicationManager.default.delegate = self
        data = HistoryManager.default.historyFor(userID: user!.userID)
        tableView.reloadData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    
        bottomConstraint.constant = -keyboardFrame.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    @IBAction func didSendButtonTap(_ sender: UIButton) {
        let message = messageTextField.text
        //CommunicationManager.default.sendMessage(message!, to: user!.userID)
    }
    
}

/*
extension ConversationViewController: CommunicationManagerDelegate {
    
    func didDataChange() {
        DispatchQueue.main.async {
            self.data = HistoryManager.default.historyFor(userID: self.user!.userID)
            self.tableView.reloadData()
        }
    }
    
}*/
