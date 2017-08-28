//
//  EdmodoServer.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/26/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation

let serverDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter
}()

let viewDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    return formatter
}()

class EdmodoServer {
    
    static let shared = EdmodoServer()
    
    fileprivate let urlSession = URLSession.shared
    fileprivate let getURL = "https://api.edmodo.com/assignments?"
    fileprivate let token = "access_token=12e7eaf1625004b7341b6d681fa3a7c1c551b5300cf7f7f3a02010e99c84695d"
}

extension EdmodoServer {
    typealias GetAssignmentsResponse = ([AssignmentModelProtocol], Error?) -> Void
    
    func getAssignments(page:Int, perPage:Int, completion: @escaping GetAssignmentsResponse) {
        
        let page = "page=\(page)"
        let perPage = "per_page=\(perPage)"
        
        let getURLFinal = URL(string: getURL+"&"+page+"&"+perPage+"&"+token)!
        
        print(getURL)
        urlSession.dataTask(with: getURLFinal) { (data, response, error) in
            
            var assignments: [Assignment]!
            
            if error != nil {
                print("Network type error")
                completion(assignments, error)
            }
            do {
                if let data = data  {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue:0)) as AnyObject
                    print(jsonResponse)
                    
                    assignments = createModel(responses: jsonResponse)
                    
                    completion(assignments, nil)
                }
                else {
                    print("json response parse to dictionary error")
                }
            }
            catch {
                print("json serialization error")
            }
            }.resume()
    }
}

fileprivate func createModel(responses:AnyObject) -> [Assignment]{
    
    var assignments = [Assignment]()
    
    guard let responseArray = responses as? [[String:AnyObject]]
        else { return assignments}
    
    for eachResponse in responseArray {
        let assignment = Assignment(json: eachResponse)
        assignments.append(assignment)
    }
    
    return assignments
}


