//
//  HistoryService.swift
//  TinkoffChat
//
//  Created by BrottyS on 06.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

protocol IHistoryService: class {
    weak var delegate: IHistoryServiceDelegate? { get set }
    func add(_ history: History)
    func lastMessageFor(userID: String) -> History?
    func historyFor(userID: String) -> [MessageModel]
}

protocol IHistoryServiceDelegate: class {
    func didAddHistory()
}

class HistoryService: IHistoryService {
    
    weak var delegate: IHistoryServiceDelegate?
    
    private let historyStorage: IHistoryStorage
    
    init(historyStorage: IHistoryStorage) {
        self.historyStorage = historyStorage
    }

    func add(_ history: History) {
        historyStorage.add(history)
    }
    
    func lastMessageFor(userID: String) -> History? {
        return historyStorage.lastMessageFor(userID: userID)
    }
    
    func historyFor(userID: String) -> [MessageModel] {
        return historyStorage.historyFor(userID: userID)
    }
    
}

extension HistoryService: IHistoryStorageDelegate {
    
    func didAddHistory() {
        delegate?.didAddHistory()
    }
    
}
