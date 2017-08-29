//
//  SubmissionDetail.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/29/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

class SubmissionDetail: UIViewController {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var submitDateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    var submission: Submission!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Image
        avatarImageView.image = #imageLiteral(resourceName: "team-placeholder")
        if let imageURL = submission.avatarLg {
            EdmodoServer.shared.downloadImage(with: imageURL) { (image, error) in
                if error == nil {
                    DispatchQueue.main.async { [weak self] in
                        self?.avatarImageView.image = image
                    }
                }
            }
        }
        
        //Set Full Name
        let firstName = submission.firstName
        let lastName = submission.lastName
        fullNameLabel.text = "\(firstName) \(lastName)"
        
        //Set submit date
        let dateString = viewDateFormatter.string(from: submission.submitDate)
        submitDateLabel.text = "Submitted on: \(dateString)"
        
        //Set Content
        contentLabel.text = submission.content
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
