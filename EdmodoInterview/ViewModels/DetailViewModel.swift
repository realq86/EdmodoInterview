//
//  DetailViewModel.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/28/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation
import UIKit

class DetailViewModel: AssignmentListViewModelProtocol {
    
    convenience required init(dataProvider: EdmodoServer) {
        self.init(dataProvider: EdmodoServer.shared, assignment:Assignment())
    }
    
    fileprivate var creatorID: Int
    fileprivate var assignmentID: Int
    fileprivate var currentPage = 1
    fileprivate var dataProvider: EdmodoServer!
    fileprivate var models: [SubmissionModelProtocol]! {
        didSet {
            var tempArray = [AssigmentCellViewModelProtocol]()
            for model in models {
                tempArray.append(SubmissionCellViewModel(model: model))
            }
            dataBackArray.value = tempArray
        }
    }
    
    var title: String = "Submissions"
    var content: String
    
    var dataBackArray: DataBinder<[AssigmentCellViewModelProtocol]>
    var isLoadingData = DataBinder(value: false)
    
    required init(dataProvider: EdmodoServer, assignment: AssignmentModelProtocol) {
        self.dataProvider = dataProvider
        self.dataBackArray = DataBinder(value: [AssigmentCellViewModelProtocol]())
        self.models = [SubmissionModelProtocol]()
        self.creatorID = assignment.creatorID
        self.assignmentID = assignment.id
        self.content = assignment.content
        self.title = assignment.title
    }
}

// MARK: - Model related methods
extension DetailViewModel {
    
    func fetchFreshModel(ifError: @escaping (Bool) -> Void) {
        
        isLoadingData.value = true
        dataProvider.getSubmissio(id: assignmentID , creator: creatorID, page: 1, perPage: 10) { [weak self] (submissions, error) in
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if error != nil {
                    ifError(true)
                    return
                }
                ifError(false)
                self?.models.append(contentsOf: submissions)
                self?.currentPage += 1
                self?.isLoadingData.value = false
            }
        }
    }
    
    func fetchNextPage(ifError: @escaping (Bool) -> Void) {
        
        isLoadingData.value = true
        dataProvider.getSubmissio(id: assignmentID , creator: creatorID, page: currentPage, perPage: 10) { [weak self] (submissions, error) in
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if error != nil {
                    ifError(true)
                    return
                }
                ifError(false)
                self?.models.append(contentsOf: submissions)
                self?.currentPage += 1
                self?.isLoadingData.value = false
            }
        }
    }
    
    func modelAt(_ index: Int) -> AnyObject? {
        if index < self.models.count {
            let model = self.models[index]
            return model as AnyObject
        }
        return nil
    }
    
    func addModel(_ model: Any) {
        //TBD
    }
}
