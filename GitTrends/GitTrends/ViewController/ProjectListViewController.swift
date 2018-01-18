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
    
    let viewModel = ProjectListViewModel(webservice: NetworkAPIClient.shared)

    // Observe listViewDataSource, initilised with empty
    private var listViewDataSource = [ProjectViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var searchTerm = "" {
        didSet {
            updateListViewWithSearchResults()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        confugureViewModel()
    }
    
    func configureUI() {
        // TableView setup
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // ActivityIndicator setup
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicator
        activityIndicator.center = tableView.center
        
        // SearchBar setup
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search treding projects"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func confugureViewModel() {
        // View model observers
        viewModel.reloadViewModel = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.listViewDataSource = strongSelf.viewModel.projectViewModels
        }
        
        viewModel.updateLoadingStatus = { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.viewModel.isLoading {
                strongSelf.activityIndicator.startAnimating()
            } else {
                strongSelf.activityIndicator.stopAnimating()
            }
        }
        viewModel.showAlertClosure = { [weak self] in
            guard let strongSelf = self else { return }
            let message = strongSelf.viewModel.error?.localizedDescription
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            strongSelf.present(alert, animated: true, completion: nil)
        }
        
        // Start fetching model data.
        viewModel.initFetch()
    }
    
    // Helper for search, this will update the datasource from viewModel
    private func updateListViewWithSearchResults() {
        guard !searchTerm.isEmpty else {
            listViewDataSource = viewModel.projectViewModels
            return
        }
        listViewDataSource = viewModel.serachResutsViewModel(searchText: searchTerm)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            destinationVC.viewModel = ProjectDetailsViewModel(project: vm.project, webservice: NetworkAPIClient.shared)
        }
    }
}

// MARK: - Search Delegae
extension ProjectListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTerm = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    }
    
}
