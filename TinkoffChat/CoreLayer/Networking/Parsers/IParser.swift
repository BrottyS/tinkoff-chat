//
//  IParser.swift
//  TinkoffChat
//
//  Created by BrottyS on 20.11.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
