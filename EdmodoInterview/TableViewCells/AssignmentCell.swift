//
//  TableViewCell.swift
//  TableViewProgrammaticallySwift
//
//  Created by Chi Hwa Michael Ting on 8/24/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

protocol AssigmentCellViewModelProtocol {
    var placeHolder:String { get }
    var mainText: String { get }
    var subText: String { get }
}

extension AssigmentCellViewModelProtocol {
    var placeHolder: String {
        get {
            return "Place_Holder"
        }
    }
}

class AssignmentCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    var viewModel:AssigmentCellViewModelProtocol! {
        didSet {
            self.titleLabel?.text = viewModel.mainText
            self.subTitleLabel?.text = viewModel.subText
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
    
    override func prepareForReuse() {
        self.textLabel?.text = ""
        self.detailTextLabel?.text = ""
    }
}
