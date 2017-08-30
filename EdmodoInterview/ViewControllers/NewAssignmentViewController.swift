//
//  NewAssignmentViewController.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/29/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

protocol NewAssignmentViewControllerDelegate: class {
    func userAddedAssignment(_ assignment: Assignment)
}

class NewAssignmentViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var dueDate: UITextField!
    @IBOutlet var assignmentDescription: UITextView!
    
    weak var delegate: NewAssignmentViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userTouchDone(_ sender: Any) {
        
        let newAssignment = createNewAssignment()
        
        //Pass newly created model to ViewModel
        delegate?.userAddedAssignment(newAssignment)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userTapOutside(_ sender: Any) {
        view.endEditing(true)
    }
    
    func createNewAssignment() -> Assignment {
        //This entire implementation should be in viewModel
        var date = Date()
        if let dueDateStr = dueDate.text, let dueDateInt = Int(dueDateStr) {
            date = Calendar.current.date(byAdding: .day, value: dueDateInt, to: Date()) ?? Date()
        }
        let newAssignment = Assignment(id: 0,
                                       creator: 0,
                                       title: (name.text ?? "No Title"),
                                       dueAt: date,
                                       content: (assignmentDescription.text ?? "No Description"))
        return newAssignment
    }
}
