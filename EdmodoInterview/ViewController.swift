//
//  ViewController.swift
//  TableViewProgrammaticallySwift
//
//  Created by Chi Hwa Michael Ting on 8/24/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

protocol TableViewModelProtocol {
    var dataBackArray:DataBinder<[TableCellViewModelProtocol]> { get }
}

let kTableViewCell = "TableViewCell"

class ViewController: UIViewController {
    
    var viewModel:TableViewModelProtocol!
    
    fileprivate var tableView:UITableView!
    fileprivate var dataBackArray:[TableCellViewModelProtocol]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        tableView = self.setupTableView(self)
        viewModel.dataBackArray.bind { [unowned self] (cellViewModels) in
            self.dataBackArray = cellViewModels
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - TableView
extension ViewController {
    
    func setupTableView(_ controller:ViewController)->UITableView {
        
        var tableView = UITableView(frame: controller.view.bounds, style: .plain)
        controller.view.addSubview(tableView)
        
        //Full Window Constraints
        let topConstraint = tableView.topAnchor.constraint(equalTo: controller.view.topAnchor)
        let leftConstraint = tableView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor)
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        let trailConstraint = tableView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, bottomConstraint, trailConstraint])
        
        tableView.dataSource = controller
        tableView.delegate = controller
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: kTableViewCell)
//        tableView.backgroundColor = .black
        
        return tableView
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBackArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCell, for: indexPath) as! TableViewCell
        cell.viewModel = dataBackArray[indexPath.row]
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    
}
