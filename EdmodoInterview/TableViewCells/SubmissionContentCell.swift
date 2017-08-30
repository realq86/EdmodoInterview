//
//  SubmissionContentCell.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/29/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

class SubmissionContentCell: UITableViewCell {

    @IBOutlet var contentLabel: UILabel!
    
    var viewModel: SubmissionCellViewModelProtocol! {
        didSet {
            contentLabel.text = viewModel.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
