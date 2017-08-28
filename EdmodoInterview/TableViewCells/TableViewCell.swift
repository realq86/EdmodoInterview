//
//  TableViewCell.swift
//  TableViewProgrammaticallySwift
//
//  Created by Chi Hwa Michael Ting on 8/24/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

protocol TableCellViewModelProtocol {
    var placeHolder:String { get }
    var mainText: String { get }
    var subText: String { get }
}

extension TableCellViewModelProtocol {
    
    var placeHolder: String {
        get {
            return "Place_Holder"
        }
    }
}

class TableViewCell: UITableViewCell {
    
    var viewModel:TableCellViewModelProtocol! {
        didSet {
            self.textLabel?.text = viewModel.placeHolder
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
