//
//  TableViewModel.swift
//  TableViewProgrammaticallySwift
//
//  Created by Chi Hwa Michael Ting on 8/24/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation

let kMockNetworkDelaySec: Double = 1

class TableViewModel: TableViewModelProtocol {
    
    fileprivate var dataProvider: EdmodoServer!
    var dataBackArray: DataBinder<[TableCellViewModelProtocol]>
    fileprivate var models: [AssignmentModelProtocol]! {
        didSet {
            var tempArray = [TableCellViewModel]()
            for model in models {
                tempArray.append(TableCellViewModel(model: model))
            }
            dataBackArray.value = tempArray
        }
    }
    var isLoadingData = DataBinder(value: false)
    fileprivate var currentPage = 1
    
    //Designated Init
    init(dataProvider: EdmodoServer) {
        self.dataProvider = dataProvider
        self.dataBackArray = DataBinder(value: [TableCellViewModel]())
        self.models = [AssignmentModelProtocol]()
    }
    
    //Init for mock testing
    convenience init(mockModels: [AssignmentModelProtocol]?) {
        self.init(dataProvider: EdmodoServer())
        self.dataBackArray = DataBinder(value: [TableCellViewModel]())
        if let models = models {
            setModel(models)
        }
    }
    
    fileprivate func setModel(_ models: [AssignmentModelProtocol]) {
        self.models = models
    }
    
    func fetchFreshModel(ifError: @escaping (Bool)->Void) {
        
        isLoadingData.value = true
        
        dataProvider.getAssignments(page: currentPage, perPage: 1) { (assignments, error) in
            DispatchQueue.main.asyncAfter(deadline: .now()+kMockNetworkDelaySec, execute: { [weak self] in
                if error != nil {
                    ifError(true)
                    return
                }
                ifError(false)
                self?.models.append(contentsOf: (assignments as [AssignmentModelProtocol]))
                self?.currentPage += 1
                self?.isLoadingData.value = false
            })
        }
    }
}

protocol AssignmentModelProtocol {
    var title: String { get }
    var dueAt: Date { get }
}

class TableCellViewModel: TableCellViewModelProtocol {
    
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
    
    var model: AssignmentModelProtocol!
    init(model:AssignmentModelProtocol) {
        self.model = model
    }
    
    let placeHolder = "PLACEHOLDER"
}
