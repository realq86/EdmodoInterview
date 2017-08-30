//
//  SubmissionModel.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/28/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation

struct Submission: SubmissionModelProtocol {
    
    var json: [String:AnyObject]!
    
    var creator: [String:AnyObject] {
        get {
            return json[kJsonCreatorKey] as! [String:AnyObject]
        }
    }
    
    var firstName: String {
        get {
            return creator[kJsonFirstNameKey] as? String ?? "default_firstName"
        }
    }
    
    var lastName: String {
        get {
            return creator[kJsonLastNamekey] as? String ?? "default_lastName"
        }
    }
    
    var avatar: (small:URL?, large:URL?) {
        get {
            let avatar = creator[kJsonAvatarKey] as! [String:String]
            let small = avatar[kJsonSm] != nil ? URL(string: avatar[kJsonSm]!) : nil
            let large = avatar[kJsonLg] != nil ? URL(string: avatar[kJsonLg]!) : nil
            
            return (small: small, large: large)
        }
    }
    
    var avatarSm: URL? {
        get {
            return avatar.small
        }
    }
    
    var avatarLg: URL? {
        get {
            return avatar.large
        }
    }
    
    var submitDate: Date {
        get {
            if let dateString = json[kJsonSubmittedAt] as? String, let date = serverDateFormatter.date(from: dateString) {
                //                print("date is \(date)")
                return date
            }
            return Date.distantFuture
        }
    }
    
    var content: String {
        get {
            return json[kJsonContent] as? String ?? "default_content"
        }
    }
    
    init(json: [String: AnyObject]) {
        self.json = json
    }
}
