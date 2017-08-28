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
            return json["id"] as? Int ?? 0
        }
    }
    var title: String {
        get {
            return json["title"] as? String ?? "default_title"
        }
    }
    var description: String {
        get {
            return json["description"] as? String ?? "default_description"
        }
    }
    var dueAt: Date
    {
        get {
            if let dateString = json["due_at"] as? String, let date = dateFormatter.date(from: dateString) {
                print("date is \(date)")
                return date
            }
            return Date.distantFuture
        }
    }
    
    init(json:[String:AnyObject]) {
        self.json = json
    }
    
    init() {
        json = [String:AnyObject]()
    }
}
