//
//  DetailViewModel.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/28/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation
import UIKit

class DetailViewModel: TableViewModelProtocol {
    
    convenience required init(dataProvider: EdmodoServer) {
        self.init(dataProvider: EdmodoServer.shared, assignment:Assignment())
    }
    
    fileprivate var creatorID: Int
    fileprivate var assignmentID: Int
    fileprivate var currentPage = 1
    fileprivate var dataProvider: EdmodoServer!
    fileprivate var models: [SubmissionModelProtocol]! {
        didSet {
            var tempArray = [TableCellViewModelProtocol]()
            for model in models {
                tempArray.append(DetailCellViewModel(model: model))
            }
            dataBackArray.value = tempArray
        }
    }
    
    var content: String
    
    var dataBackArray: DataBinder<[TableCellViewModelProtocol]>
    var isLoadingData = DataBinder(value: false)
    
    
    required init(dataProvider: EdmodoServer, assignment: AssignmentModelProtocol) {
        self.dataProvider = dataProvider
        self.dataBackArray = DataBinder(value: [TableCellViewModelProtocol]())
        self.models = [SubmissionModelProtocol]()
        self.creatorID = assignment.creatorID
        self.assignmentID = assignment.id
        self.content = assignment.content
    }
    
    func fetchFreshModel(ifError: @escaping (Bool) -> Void) {
        
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
}

protocol SubmissionModelProtocol {
    var firstName: String { get }
    var lastName: String { get }
    var avatarSm: URL? { get }
    var avatarLg: URL? { get }
    var submitDate: Date { get }
    var content: String { get }
}

class DetailCellViewModel: SubmissionCellViewModelProtocol {
    
    var model: SubmissionModelProtocol!
    var firstName: DataBinder<String>
    var lastName: DataBinder<String>
    var submitDate: DataBinder<Date>
    var content: String
    let placeHolder = "DetailViewPlaceHolder"
    
    var mainText: String {
        get {
            return self.model.firstName
        }
    }
    
    var subText: String {
        get {
            let displayDate = viewDateFormatter.string(from: self.model.submitDate)
            print("Date description is \(displayDate)")
            return displayDate
        }
    }
    
    var avatarDownloaded: Bool = false
    fileprivate var _avatarSm: DataBinder<UIImage>
    var avatarSm: DataBinder<UIImage> {
        get {
            if !avatarDownloaded {
                downloadAvatar()
            }
            return _avatarSm
        }
        set {
            _avatarSm = newValue
        }
    }
    
    init(model: SubmissionModelProtocol) {
        self.model = model
        firstName = DataBinder(value: model.firstName)
        lastName = DataBinder(value: model.lastName)
        submitDate = DataBinder(value: model.submitDate)
        _avatarSm = DataBinder(value: #imageLiteral(resourceName: "team-placeholder"))
        content = model.content
    }
    
    func downloadAvatar() {
        if !avatarDownloaded {
            if let url = model.avatarSm {
                EdmodoServer.shared.downloadImage(with: url, completion: { (image, error) in
                    if let image = image {
                        DispatchQueue.main.async { [weak self] in
                            self?.avatarSm.value = image
                            self?.avatarDownloaded = true
                        }
                    }
                })
            }
        }
    }
}
