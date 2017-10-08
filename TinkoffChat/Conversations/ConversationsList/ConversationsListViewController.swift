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
    
    private let data = [
        // online
        [ConversationModel(name: "Мать Драконов",
                           message: "Ты не видел Дракариса?",
                           date: Date(from: "07.10.2017 15:05"),
                           online: true,
                           hasUnreadMessages: true),
         ConversationModel(name: "Джон Сноу",
                           message: "Да не знал я, что она моя тетя!",
                           date: Date(from: "08.10.2017 17:25"),
                           online: true,
                           hasUnreadMessages: false),
         ConversationModel(name: "Арья Старк",
                           message: "Валар Моргулис",
                           date: nil,
                           online: true,
                           hasUnreadMessages: true),
         ConversationModel(name: "Санса Старк",
                           message: "Как думаешь, Мизинцу можно доверять?",
                           date: nil,
                           online: true,
                           hasUnreadMessages: false),
         ConversationModel(name: "Серсея Ланнистер",
                           message: nil,
                           date: Date(from: "05.10.2017 00:00"),
                           online: true,
                           hasUnreadMessages: true),
         ConversationModel(name: "Nobody",
                           message: nil,
                           date: Date(from: "08.10.2017 00:00"),
                           online: true,
                           hasUnreadMessages: false),
         ConversationModel(name: "Сэм",
                           message: nil,
                           date: nil,
                           online: true,
                           hasUnreadMessages: true),
         ConversationModel(name: "Роб Старк",
                           message: nil,
                           date: nil,
                           online: true,
                           hasUnreadMessages: false),
         ConversationModel(name: "Тирион Ланнистер",
                           message: "Пусть боги решают мою судьбу. Я требую суда поединком!",
                           date: Date(from: "09.10.2017 15:05"),
                           online: true,
                           hasUnreadMessages: true),
         ConversationModel(name: "Ходор",
                           message: "Ходор! Ходор! Ходор!",
                           date: Date(from: "09.10.2017 17:25"),
                           online: true,
                           hasUnreadMessages: false),],
        // history
        [ConversationModel(name: "Мать Драконов",
                           message: "Ты не видел Дракариса?",
                           date: Date(from: "07.10.2017 15:05"),
                           online: false,
                           hasUnreadMessages: true),
         ConversationModel(name: "Джон Сноу",
                           message: "Да не знал я, что она моя тетя!",
                           date: Date(from: "08.10.2017 17:25"),
                           online: false,
                           hasUnreadMessages: false),
         ConversationModel(name: "Арья Старк",
                           message: "Валар Моргулис",
                           date: nil,
                           online: false,
                           hasUnreadMessages: true),
         ConversationModel(name: "Санса Старк",
                           message: "Как думаешь, Мизинцу можно доверять?",
                           date: nil,
                           online: false,
                           hasUnreadMessages: false),
         ConversationModel(name: "Серсея Ланнистер",
                           message: "Да гори оно все зеленым пламенем...",
                           date: Date(from: "05.10.2017 00:00"),
                           online: false,
                           hasUnreadMessages: true),
         ConversationModel(name: "Джордж Мартин",
                           message: "Есть любимый персонаж? Он умрет.",
                           date: Date(from: "08.10.2017 00:00"),
                           online: false,
                           hasUnreadMessages: false),
         ConversationModel(name: "Сэм",
                           message: "Не подскажешь, как пройти к библиотеке?",
                           date: nil,
                           online: false,
                           hasUnreadMessages: true),
         ConversationModel(name: "Роб Старк",
                           message: "Любое действие имеет колоссальные последствия",
                           date: nil,
                           online: false,
                           hasUnreadMessages: false),
         ConversationModel(name: "Тирион Ланнистер",
                           message: "Пусть боги решают мою судьбу. Я требую суда поединком!",
                           date: Date(from: "09.10.2017 15:05"),
                           online: false,
                           hasUnreadMessages: true),
         ConversationModel(name: "Ходор",
                           message: "Ходор! Ходор! Ходор!",
                           date: Date(from: "09.10.2017 17:25"),
                           online: false,
                           hasUnreadMessages: false),]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ConversationCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: conversationCellId) as? ConversationCell {
            cell = dequeuedCell
        } else {
            cell = ConversationCell(style: .default, reuseIdentifier: conversationCellId)
        }
        
        let conversation = data[indexPath.section][indexPath.row]
        cell.name = conversation.name
        cell.date = conversation.date
        cell.message = conversation.message
        cell.online = conversation.online
        cell.hasUnreadMessages = conversation.hasUnreadMessages
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
            
        case 1:
            return "History"
            
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
                let conversation = data[indexPath.section][indexPath.row]
                
                if let conversationVC = segue.destination as? ConversationViewController {
                    conversationVC.navigationItem.title = conversation.name
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
