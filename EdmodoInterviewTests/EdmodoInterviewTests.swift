//
//  EdmodoInterviewTests.swift
//  EdmodoInterviewTests
//
//  Created by Chi Hwa Michael Ting on 8/26/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import XCTest
@testable import EdmodoInterview

class EdmodoInterviewTests: XCTestCase {
    
    let shared = EdmodoServer.shared
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testJsonResponseNotNil() {
        let expectation = self.expectation(description: "Response not nil")
        
        shared.getAssignments(page:1, perPage:1) { (response, error) in
            if error == nil {
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testGetFirstAssignment() {
        
        let expectArrayOfAssignments = self.expectation(description: "Got array of assignments")
        
        let expectFirstAssignmentID = self.expectation(description: "First Assignment have id")
        
        let expectFirstTitle = self.expectation(description: "First Assignment title valid")
        
        let expected1stDescription = self.expectation(description: "First Assignment description valid")
        
        let expectedDueDate = self.expectation(description: "First Assignment due date valid")
        
        shared.getAssignments(page: 1, perPage: 1) { (assignments, error) in
            
            //Array not nil
            guard let firstAssignment = assignments.first
                else {
                    expectArrayOfAssignments.fulfill()
                    return
            }
            expectArrayOfAssignments.fulfill()
            
            //ID
            guard let id = firstAssignment.id
                else {return}
            (id == 24800159) ? expectFirstAssignmentID.fulfill() : print("///// first ID is \(firstAssignment.id)")
            
            //Title
            guard let title = firstAssignment.title
                else {return}
            title == "The Digestive System" ? expectFirstTitle.fulfill() : print("///// first title is \(title)")
            
            //Description
            guard let description = firstAssignment.description
                else {return}
            description == "Choose an organ in the digestive system, and write a short description of what it does." ? expected1stDescription.fulfill() : print("//// first description is\(description)")
            
            guard let dueAt = firstAssignment.dueAt
                else {
                    return
            }
            print("/////// Due at = \(dueAt)")
            expectedDueDate.fulfill()
        }
        
        self.wait(for: [expectArrayOfAssignments, expectFirstAssignmentID, expectFirstTitle, expected1stDescription, expectedDueDate], timeout: 5)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
