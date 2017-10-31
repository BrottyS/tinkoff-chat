//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

enum Section: Int {
    case online = 0
    case offline
}

class ConversationListViewController: UIViewController, ConversationListModelDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    
    private var dataSource: [ConversationListViewModel] = []
    private let model: IConversationListModel
    
    init(model: IConversationListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        model.getOnlineUsers()
    }

    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ConversationListTableViewCell", bundle: nil), forCellReuseIdentifier: "\(ConversationListTableViewCell.self)")
    }
    
    // MARK: - IConversationListModelDelegate
    
    func setupDataSource(_ dataSource: [ConversationListViewModel]) {
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ConversationListTableViewCell.self)", for: indexPath) as! ConversationListTableViewCell
        let conversationListVM = dataSource[indexPath.row]
        cell.configure(with: conversationListVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.online.rawValue:
            return "Online"
            
        default:
            return nil
        }
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
