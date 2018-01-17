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
    private let searchController = UISearchController(searchResultsController: nil)
    
    static let projectDetailSegue = "ProjectDetailSegue"
    static let projectListCellIdentifier = "ProjectCellIdentifier"
    // Observe listViewDataSource
    private var listViewDataSource = [ProjectViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // This will be a original copy of listViewDataSource, stored when we fetch listViewDataSource from service, we are goig to apply filter on this for srarch.
    private var originalDataSource = [ProjectViewModel]()
    
    private var searchTerm = "" {
        didSet {
            updateListViewWithSearchResults()
        }
    }
    
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
        
        //SearchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search treding projects"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        let apiService = NetworkAPIClient.shared
        activityIndicator.startAnimating()
        apiService.fetchTrendingProjects { (projecList, error) in
            DispatchQueue.main.sync { [weak self] in
                self?.listViewDataSource = (projecList?.projectsListViewModel())!
                self?.activityIndicator.stopAnimating()
                self?.originalDataSource = (self?.listViewDataSource)!
            }
        }
    }
    
    private func updateListViewWithSearchResults() {
        guard !searchTerm.isEmpty else {
            listViewDataSource = originalDataSource
            return
        }
        
        listViewDataSource = originalDataSource.filter { $0.projectName.lowercased().contains(searchTerm.lowercased()) ||  $0.projectDescription.lowercased().contains(searchTerm.lowercased()) }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listViewDataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectListViewController.projectListCellIdentifier, for: indexPath) as? ProjectListViewCell else {
            return UITableViewCell()
        }
        let prjViewModel = listViewDataSource[indexPath.row]
        cell.configureCell(with: prjViewModel)
        return cell        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: ProjectListViewController.projectDetailSegue, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  ProjectListViewController.projectDetailSegue, let destinationVC = segue.destination as? ProjectDetailsViewController, let indexPath = self.tableView.indexPathForSelectedRow {
            let vm = listViewDataSource[indexPath.row]
            destinationVC.viewModel = ProjectDetailsViewModel(project: vm.project)
        }
    }
}

// MARK: - Search Delegae
extension ProjectListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTerm = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    }
    
}
