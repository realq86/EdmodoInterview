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
    fileprivate var currentPage = 1
    fileprivate var dataProvider: EdmodoServer!
    fileprivate var models: [AssignmentModelProtocol]! {
        didSet {
            var tempArray = [TableCellViewModelProtocol]()
            for model in models {
                tempArray.append(TableCellViewModel(model: model))
            }
            dataBackArray.value = tempArray
        }
    }
    var content: String = ""
    var dataBackArray: DataBinder<[TableCellViewModelProtocol]>
    var isLoadingData = DataBinder(value: false)
    
    //Designated Init
    required init(dataProvider: EdmodoServer) {
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
        dataProvider.getAssignments(page: 1, perPage: 1) { (assignments, error) in
            DispatchQueue.main.asyncAfter(deadline: .now()+kMockNetworkDelaySec, execute: { [weak self] in
                if error != nil {
                    ifError(true)
                    return
                }
                ifError(false)
                self?.models = assignments
                self?.currentPage = 2
                self?.isLoadingData.value = false
            })
        }
    }
    
    func fetchNextPage(ifError: @escaping (Bool)->Void) {
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
    
    func modelAt(_ index: Int) -> AnyObject? {
        if index < self.models.count {
            let model = self.models[index]
            return model as AnyObject
        }
        return nil
    }
}


