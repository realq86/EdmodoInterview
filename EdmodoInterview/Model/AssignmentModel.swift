//
//  AssignmentModel.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/27/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation

struct Assignment: AssignmentModelProtocol {
    
    var json: [String:AnyObject]!
    
    var id: Int {
        get {
            return json[kJsonID] as? Int ?? 0
        }
    }
    var title: String {
        get {
            return json[kJsonTitle] as? String ?? "default_title"
        }
    }
    var description: String {
        get {
            return json[kJsonDescriptionKey] as? String ?? "default_description"
        }
    }
    var dueAt: Date
    {
        get {
            if let dateString = json[kJsonDueAt] as? String, let date = serverDateFormatter.date(from: dateString) {
//                print("date is \(date)")
                return date
            }
            return Date.distantFuture
        }
    }
    var creator: [String: AnyObject] {
        get {
            return json[kJsonCreatorKey] as? [String:AnyObject] ?? [String:AnyObject]()
        }
    }
    
    var creatorID: Int {
        get {
            return creator[kJsonID] as? Int ?? 0
        }
    }
    
    var content: String {
        get {
            return json[kJsonDescriptionKey] as? String ?? "default_description"
        }
    }
    
    init(json:[String:AnyObject]) {
        self.json = json
    }
    
    init(id: Int, creator: Int, title: String, dueAt: Date, content: String) {
        
        var temp = [String:AnyObject]()
        temp[kJsonID] = NSNumber(integerLiteral: 9999)
        temp[kJsonCreatorKey] = NSNumber(integerLiteral: 1111)
        temp[kJsonTitle] = title as NSString
        temp[kJsonDescriptionKey] = content as NSString
        temp[kJsonDueAt] = serverDateFormatter.string(from: dueAt) as NSString
        self.init(json: temp)
    }
    
    init() {
        self.init(id: 0, creator: 0, title: "", dueAt: Date.distantFuture, content: "")
    }
}


