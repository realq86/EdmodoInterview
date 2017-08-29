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
            return json["creator"] as! [String:AnyObject]
        }
    }
    
    var firstName: String {
        get {
            return creator["first_name"] as? String ?? "default_firstName"
        }
    }
    
    var lastName: String {
        get {
            return creator["last_name"] as? String ?? "default_lastName"
        }
    }
    
    var avatar: (small:URL?, large:URL?) {
        get {
            let avatar = creator["avatars"] as! [String:String]
            let small = avatar["small"] != nil ? URL(string: avatar["small"]!) : nil
            let large = avatar["large"] != nil ? URL(string: avatar["large"]!) : nil
            
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
            if let dateString = json["submitted_at"] as? String, let date = serverDateFormatter.date(from: dateString) {
                //                print("date is \(date)")
                return date
            }
            return Date.distantFuture
        }
    }
    
    var content: String {
        get {
            return json["content"] as? String ?? "default_content"
        }
    }
    
    init(json: [String: AnyObject]) {
        self.json = json
    }
}
