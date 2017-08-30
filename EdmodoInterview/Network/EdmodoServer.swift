//
//  EdmodoServer.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/26/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import Foundation
import UIKit

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
    fileprivate let urlSession = URLSession.shared //More work to be done to have different session instead of singleton
}

extension EdmodoServer {
    typealias GetAssignmentsResponse = ([AssignmentModelProtocol], Error?) -> Void
    
    func getAssignments(page:Int, perPage:Int, completion: @escaping GetAssignmentsResponse) {
        
        let page = "page=\(page)"
        let perPage = "per_page=\(perPage)"
        
        let getURLFinal = URL(string: kGetAssignmentURL+"&"+page+"&"+perPage+"&"+kToken)!
        
        print(kGetAssignmentURL)
        urlSession.dataTask(with: getURLFinal) { (data, response, error) in
            
            var assignments: [Assignment]!
            
            if error != nil {
                print(kGeneralNetowrkErrorMsg)
                completion(assignments, error)
            }
            do {
                if let data = data  {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue:0)) as AnyObject
                    print(jsonResponse)
                    
                    assignments = createAssignmentModel(responses: jsonResponse)
                    
                    completion(assignments, nil)
                }
                else {
                    print(kDatadownloadErrorMsg)
                }
            }
            catch {
                print(kJsonSerialErrorMsg)
            }
            }.resume()
    }
    
    typealias GetSubmissionsResponse = ([SubmissionModelProtocol], Error?) -> Void
    func getSubmissio(id:Int, creator:Int, page:Int, perPage:Int, completion: @escaping GetSubmissionsResponse) {
        
        let page = "page=\(page)"
        let perPage = "per_page=\(perPage)"
        let assignmentID = "assignment_id=\(id)"
        let assignmentCreator = "assignment_creator_id=\(creator)"
        let getWithPage = kGetSubmissionURL + "&" + page + "&" + perPage
        let withAssignmentID = getWithPage + "&" + assignmentID + "&" + assignmentCreator + "&" + kToken
        let getURLFinal = URL(string: withAssignmentID)!
        
        print(kGetAssignmentURL)
        urlSession.dataTask(with: getURLFinal) { (data, response, error) in
            
            var assignments: [SubmissionModelProtocol]!
            
            if error != nil {
                print(kGeneralNetowrkErrorMsg)
                completion(assignments, error)
            }
            do {
                if let data = data  {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue:0)) as AnyObject
                    print(jsonResponse)
                    
                    assignments = createSubmissionModel(responses: jsonResponse)
                    
                    completion(assignments, nil)
                }
                else {
                    print(kDatadownloadErrorMsg)
                }
            }
            catch {
                print(kJsonSerialErrorMsg)
            }
            }.resume()
    }
    typealias ImageDownloadComplete = (UIImage?, Error?)->Void
    func downloadImage(with url:URL, completion: @escaping ImageDownloadComplete) {
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil && data != nil{
                completion(nil, error)
                return
            }
            if let data = data {
                let image = UIImage(data: data)
                completion(image, error)
            }
        }.resume()
    }
}

// MARK: - Helper
fileprivate func createSubmissionModel(responses: AnyObject) -> [Submission] {
    var submissions = [Submission]()
    
    guard let responseArray = responses as? [[String:AnyObject]]
        else { return submissions}
    
    for eachResponse in responseArray {
        let submission = Submission(json: eachResponse)
        submissions.append(submission)
    }
    
    return submissions
}

fileprivate func createAssignmentModel(responses: AnyObject) -> [Assignment] {
    
    var assignments = [Assignment]()
    
    guard let responseArray = responses as? [[String:AnyObject]]
        else { return assignments}
    
    for eachResponse in responseArray {
        let assignment = Assignment(json: eachResponse)
        assignments.append(assignment)
    }
    
    return assignments
}


