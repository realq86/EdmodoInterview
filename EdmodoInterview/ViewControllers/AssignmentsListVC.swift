//
//  ViewController.swift
//  TableViewProgrammaticallySwift
//
//  Created by Chi Hwa Michael Ting on 8/24/17.
//  Copyright © 2017 Chi Hwa Michael Ting. All rights reserved.
//

import UIKit

protocol AssignmentListViewModelProtocol {
    var title: String { get }
    var content: String { get }
    var dataBackArray: DataBinder<[AssigmentCellViewModelProtocol]> { get }
    var isLoadingData: DataBinder<Bool> { get }
    init(dataProvider: EdmodoServer)
    func fetchFreshModel(ifError: @escaping (Bool)->Void)
    func fetchNextPage(ifError: @escaping (Bool)->Void)
    func modelAt(_ index: Int) -> AnyObject?
    func addModel(_ model:Any)
}

class AssignmentsListVC: UIViewController {
    
    let kTableViewCell = "AssignmentCell"
    
    var viewModel:AssignmentListViewModelProtocol!
    var tableView:UITableView!
    var dataBackArray:[AssigmentCellViewModelProtocol]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Assignments"
        
        tableView = self.setupTableView(self)
        
        //Data bind to listen to changes to data array
        viewModel.dataBackArray.bind { [unowned self] (cellViewModels) in
            self.dataBackArray = cellViewModels
                self.tableView.reloadData()
        }
        
        //Setup ActivityView and listen to viewModel's isLoadingData property.
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = view.center
        view.addSubview(activityView)
        viewModel.isLoadingData.bind { (isLoading) in
            isLoading ? activityView.startAnimating() : activityView.stopAnimating()
        }
        
        //Call fetch network on 1st load.
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
        
        let tableView = UITableView(frame: .zero, style: .plain)
        controller.view.addSubview(tableView)
        
        //Full Window Constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = tableView.topAnchor.constraint(equalTo: controller.view.topAnchor)
        let leftConstraint = tableView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor)
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        let trailConstraint = tableView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, bottomConstraint, trailConstraint])
        
        //Delegate, dataSource, and size setup
        tableView.dataSource = controller
        tableView.delegate = controller
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let nib = UINib(nibName: kTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kTableViewCell)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCell, for: indexPath) as! AssignmentCell
        cell.viewModel = dataBackArray[indexPath.row]
        
        return cell
    }
}

// MARK: TableView Delegate
extension AssignmentsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let assignment = viewModel.modelAt(indexPath.row) as! AssignmentModelProtocol
        self.performSegue(withIdentifier: kSegueIDToSubmission, sender: assignment)
    }
}

// MARK: Load next page
extension AssignmentsListVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !viewModel.isLoadingData.value {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetLevel = scrollViewContentHeight - tableView.bounds.height*0.8
            
            //Check user scrolling down
            let isDown = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y < 0
            
            //Load next page
            if scrollView.contentOffset.y > scrollOffsetLevel && isDown {
                viewModel.fetchNextPage { [unowned self] (isError) in
                    if isError {
                        let alert = UIAlertController(title: kGeneralNetowrkErrorMsg, message: nil, preferredStyle: .alert)
                        self.present(alert, animated: true)
                    }
                }
            }
            
            //Pull to refresh
            if scrollView.contentOffset.y < 0 && !isDown {
                viewModel.fetchFreshModel { [unowned self] (isError) in
                    if isError {
                        let alert = UIAlertController(title: kGeneralNetowrkErrorMsg, message: nil, preferredStyle: .alert)
                        self.present(alert, animated: true)
                    }
                }
            }
        }  
    }
}

// MARK: - Add New Assignment
extension AssignmentsListVC: NewAssignmentViewControllerDelegate {
    
    func userAddedAssignment(_ assignment: Assignment) {
        viewModel.addModel(assignment)
    }
}

// MARK: - Navigation
extension AssignmentsListVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kSegueIDPresentNewAssignmentVC {
            let newAssignmentVC = segue.destination as! NewAssignmentViewController
            newAssignmentVC.delegate = self
        }
        
        if segue.identifier == kSegueIDToSubmission {
            let assignment = sender as! Assignment
            let assignmentDetailVC = segue.destination as! SubmissionListVC
            assignmentDetailVC.viewModel = DetailViewModel(dataProvider: EdmodoServer.shared, assignment: assignment)
        }
    }
}
