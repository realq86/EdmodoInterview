//
//  DetailCellViewModel.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/29/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation
import UIKit

protocol SubmissionModelProtocol {
    var firstName: String { get }
    var lastName: String { get }
    var avatarSm: URL? { get }
    var avatarLg: URL? { get }
    var submitDate: Date { get }
    var content: String { get }
}

class SubmissionCellViewModel: SubmissionCellViewModelProtocol {
    
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
        if avatarDownloaded {
            return
        }
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
