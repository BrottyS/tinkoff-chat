//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 08.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private constants
    
    private let conversationCellId = "ConversationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CommunicationManager.default.delegate = self
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommunicationManager.default.onlineUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ConversationCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: conversationCellId) as? ConversationCell {
            cell = dequeuedCell
        } else {
            cell = ConversationCell(style: .default, reuseIdentifier: conversationCellId)
        }
        
        let user = CommunicationManager.default.onlineUsers[indexPath.row]
        cell.name = user.userName
        
        if let lastMessage = HistoryManager.default.lastMessageFor(userID: user.userID) {
            cell.date = lastMessage.date
            cell.message = lastMessage.message.text
        } else {
            cell.date = nil
            cell.message = nil
        }
        
        cell.online = true
        cell.hasUnreadMessages = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
            
        default:
            return nil
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToConversationDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let user = CommunicationManager.default.onlineUsers[indexPath.row]
                
                if let conversationVC = segue.destination as? ConversationViewController {
                    conversationVC.user = user
                    conversationVC.navigationItem.title = user.userName
                }
            }
        }
    }
    
    @IBAction func didProfileBarButtonItemTap(_ sender: UIBarButtonItem) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        present(profileNavigationController, animated: true, completion: nil)
    }
    
}

extension ConversationsListViewController: CommunicationManagerDelegate {
    
    func didDataChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
