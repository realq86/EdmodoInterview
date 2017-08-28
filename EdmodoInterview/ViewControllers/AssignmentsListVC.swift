//
//  ViewController.swift
//  TableViewProgrammaticallySwift
//
//  Created by Chi Hwa Michael Ting on 8/24/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

let kTableViewCell = "TableViewCell"

protocol TableViewModelProtocol {
    var dataBackArray: DataBinder<[TableCellViewModelProtocol]> { get }
    
    var isLoadingData: DataBinder<Bool> { get }
    func fetchFreshModel(ifError: @escaping (Bool)->Void)
}

class AssignmentsListVC: UIViewController {
    
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
        
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = view.center
        view.addSubview(activityView)
        viewModel.isLoadingData.bind { (isLoading) in
            isLoading ? activityView.startAnimating() : activityView.stopAnimating()
        }
        viewModel.fetchFreshModel { [unowned self] (isError) in
            if isError {
                let alert = UIAlertController(title: "NetworkError", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - TableView
extension AssignmentsListVC {
    
    func setupTableView(_ controller:AssignmentsListVC)->UITableView {
        
        let tableView = UITableView(frame: controller.view.bounds, style: .plain)
        controller.view.addSubview(tableView)
        
        //Full Window Constraints
        let topConstraint = tableView.topAnchor.constraint(equalTo: controller.view.topAnchor)
        let leftConstraint = tableView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor)
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        let trailConstraint = tableView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, bottomConstraint, trailConstraint])
        
        tableView.dataSource = controller
        tableView.delegate = controller
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let nib = UINib(nibName: kTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kTableViewCell)
        tableView.backgroundColor = .black
        
        return tableView
    }
}

// MARK: TableView Data Source
extension AssignmentsListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBackArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCell, for: indexPath) as! TableViewCell
        
        cell.viewModel = dataBackArray[indexPath.row]
        
        return cell
    }
}

// MARK: TableView Delegate
extension AssignmentsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let assignmentDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssignmentDetailVC")
        
        self.navigationController?.show(assignmentDetailVC, sender: self)
    }
    
}

// MARK: Load next page
extension AssignmentsListVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !viewModel.isLoadingData.value {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetLevel = scrollViewContentHeight - tableView.bounds.height
            
            if scrollView.contentOffset.y > scrollOffsetLevel && tableView.isDragging {
                viewModel.fetchFreshModel { [unowned self] (isError) in
                    if isError {
                        let alert = UIAlertController(title: "NetworkError", message: nil, preferredStyle: .alert)
                        self.present(alert, animated: true)
                    }
                }
            }
        }  
    }
}
