//
//  ProjectListViewController.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import UIKit

class ProjectListViewController: UITableViewController {

    private var activityIndicator: UIActivityIndicatorView!
    static let projectDetailSegue = "ProjectDetailSegue"
    static let projectListCellIdentifier = "ProjectCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    func configureUI() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicator
        activityIndicator.center = tableView.center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectListViewController.projectListCellIdentifier, for: indexPath) as! ProjectListViewCell
//        cell.configureCell(projectCellView: projectListViewModel.cellViewModel(at: indexPath))
        return cell

    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ProjectListViewController.projectDetailSegue, sender: self)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  ProjectListViewController.projectDetailSegue, let destinationVC = segue.destination as? ProjectDetailsViewController, let indexPath = self.tableView.indexPathForSelectedRow {
        }
        
    }


}
