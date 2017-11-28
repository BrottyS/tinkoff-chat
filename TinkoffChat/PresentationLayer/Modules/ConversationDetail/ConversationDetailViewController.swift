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

class ConversationDetailViewController: UIViewController, ConversationDetailModelDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Private properties
    
    private var dataSource: [ConversationDetailViewModel] = []
    private let model: IConversationDetailModel
    
    private let kDisabledSendButtonColor = UIColor.lightGray
    private let kEnabledSendButtonColor = UIColor.blue
    
    private var isUserOnline = true
    
    init(model: IConversationDetailModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        messageTextField.delegate = self
        
        messageTextField.addTarget(self, action: #selector(messageTextFieldDidChange(_:)), for: .editingChanged)
        
        configureTableView()
        
        // TODO: something like model.requestForUpdates()
        //model.getOnlineUsers()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.setupCommunicationServiceDelegate()
        model.getOnlineUsers()
        
        toggleSendButton()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IncomingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: kIncomingMessageCellId)
        tableView.register(UINib(nibName: "OutgoingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: kOutgoingMessageCellId)
    }
    
    private func toggleSendButton() {
        if sendButton.isEnabled {
            guard !isUserOnline || messageTextField.text == nil || messageTextField.text! == "" else { return }
        } else {
            print(isUserOnline)
            print(messageTextField.text!)
            guard isUserOnline && messageTextField.text != nil && messageTextField.text! != "" else { return }
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.sendButton.tintColor = self.sendButton.isEnabled ? self.kDisabledSendButtonColor : self.kEnabledSendButtonColor
            self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.sendButton.transform = CGAffineTransform.identity
                self.sendButton.isEnabled = !self.sendButton.isEnabled
            }
        })
    }
    
    private func toggleTitle() {
        
    }
    
    // MARK: - UITextFieldDelegate
    
    @objc func messageTextFieldDidChange(_ textField: UITextField) {
        toggleSendButton()
    }
    
    // MARK: - ConversationDetailModelDelegate
    
    func setupDataSource(_ dataSource: [ConversationDetailViewModel]) {
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func userBecomeOnline() {
        isUserOnline = true
        toggleSendButton()
    }
    
    func userBecomeOffline() {
        isUserOnline = false
        toggleSendButton()
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
