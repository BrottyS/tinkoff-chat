//
//  ConversationDetailViewController.swift
//  TinkoffChat
//
//  Created by BrottyS on 31.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class ConversationDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
