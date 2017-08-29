//
//  TableCellViewModel.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/29/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation

protocol AssignmentModelProtocol {
    var title: String { get }
    var dueAt: Date { get }
    var content: String { get }
    var creatorID: Int { get }
    var id: Int { get }
}

class TableCellViewModel: TableCellViewModelProtocol {
    
    var model: AssignmentModelProtocol!
    let placeHolder = "PLACEHOLDER"
    
    var mainText: String {
        get {
            return self.model.title
        }
    }
    
    var subText: String {
        get {
            let displayDate = viewDateFormatter.string(from: self.model.dueAt)
            print("Date description is \(displayDate)")
            return displayDate
        }
    }
    
    init(model: AssignmentModelProtocol) {
        self.model = model
    }
}
