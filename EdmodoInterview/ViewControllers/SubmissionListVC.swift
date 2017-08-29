//
//  AssignmentDetailVC.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/28/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

class SubmissionListVC: AssignmentsListVC {
    
    let kSubmissionCell = "SubmissionCell"
    let kSubmissionContentCell = "SubmissionContentCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        //Setup TableViewCells needed for this VC
        var nib = UINib(nibName: kSubmissionCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kSubmissionCell)
        nib = UINib(nibName: kSubmissionContentCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kSubmissionContentCell)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SubmissionListVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //For top section with content of this Assignment
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kSubmissionContentCell, for: indexPath) as! SubmissionContentCell            
            cell.contentLabel.text = viewModel.content
            return cell
        }
        //For list of students submissions.
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kSubmissionCell, for: indexPath) as! SubmissionCell
            let viewModels = self.dataBackArray as! [SubmissionCellViewModelProtocol]
            cell.viewModel = viewModels[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if let submission = viewModel.modelAt(indexPath.row) as? Submission {
                performSegue(withIdentifier: "SegueToSubmissionDetail", sender: submission)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let destination = segue.destination as! SubmissionDetail
        destination.submission = sender as! Submission
        destination.title = title
    }
}
