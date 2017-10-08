//
//  DateExtensions.swift
//  TinkoffChat
//
//  Created by BrottyS on 08.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

extension Date {
    
    init?(from: String) {
        guard !from.isEmpty else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        guard let date = dateFormatter.date(from: from) else { return nil }
        
        self.init(timeInterval: 0, since: date)
    }
    
}
