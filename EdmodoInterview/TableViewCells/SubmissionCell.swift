//
//  SubmissionCell.swift
//  EdmodoInterview
//
//  Created by Chi Hwa Michael Ting on 8/28/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

protocol SubmissionCellViewModelProtocol: AssigmentCellViewModelProtocol {
    var firstName: DataBinder<String> { get }
    var lastName: DataBinder<String> { get }
    var avatarSm: DataBinder<UIImage> { get }
    var submitDate: DataBinder<Date> { get }
    var content: String { get }
}

class SubmissionCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var submitDateLabel: UILabel!
    
    var viewModel: SubmissionCellViewModelProtocol! {
        didSet {
            fullNameLabel.text = "\(viewModel.firstName.value) \(viewModel.lastName.value)"
            submitDateLabel.text = "Submitted At: \(viewModel.subText)"
            
            let image = viewModel.avatarSm.value
            avatarImageView.image = image
            
            //Listen to download complete of avatar pics.
            viewModel.avatarSm.bind { [weak self] (image) in
                self?.avatarImageView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        avatarImageView.image = #imageLiteral(resourceName: "team-placeholder")
    }
}
