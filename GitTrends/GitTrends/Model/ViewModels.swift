//
//  ViewModels.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import Foundation


class ProjectListViewModel {
    
    internal let webservice: NetworkAPIClientProtocol!
    
    // DI
    init(webservice: NetworkAPIClientProtocol) {
        self.webservice = webservice
    }
    
    var projectViewModels = [ProjectViewModel]() {
        didSet {
            self.reloadViewModel?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var error: Error? = nil {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    // Call backs to be implemented by listener
    var reloadViewModel: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    func serachResutsViewModel(searchText: String) -> [ProjectViewModel] {
        return projectViewModels.filter { $0.projectName.lowercased().contains(searchText.lowercased()) ||  $0.projectDescription.lowercased().contains(searchText.lowercased())
        }

    }
    let numberOfSections = 1
}

extension ProjectListViewModel {

    func initFetch() {
        self.isLoading = true
        DispatchQueue.global().async { [weak self] in
            self?.webservice.fetchTrendingProjects(complete: { (projectsList, error) in
                DispatchQueue.main.sync {
                    self?.isLoading = false
                    if let projects = projectsList {
                        let vms = projects.projects.map {
                            return ProjectViewModel(project: $0)
                        }
                        self?.projectViewModels = vms
                    } else {
                        self?.error = error
                    }
                }
            })
        }
    }
}

struct ProjectViewModel {
    let projectID: Int
    let projectName: String // or repo name
    let projectDescription: String
    let stars: String
    let project: Project
    
    init(project: Project) {
        projectID = project.id
        projectName = project.name
        projectDescription = project.details
        stars = "\(project.stars) Starts"
        self.project = project
    }
}

struct ProjectDetailsViewModel {
    let projectName: String
    let profileImageURL: URL?
    let userName: String
    let description: String
    let stars: String
    let forks: String
    let readmeRequestURL: URL?
    let id: Int
    let webservice: NetworkAPIClientProtocol
    
    var loadReadMeHTML: (()->())?
    init(project: Project, webservice: NetworkAPIClientProtocol) {
        
        projectName = project.name
        profileImageURL = project.owner.profileURL
        userName = project.owner.userName
        description = project.details
        stars = "\(project.stars) Starts"
        forks = "\(project.forks) Forks"
        readmeRequestURL = project.readmeRequestURL
        id = project.id
        self.webservice = webservice
    }
}

struct ReadMeViewModel {
    var htmlURL: String
    var downloadURL: String
    
    init(htmlURL: String, downloadURL: String) {
        self.htmlURL = htmlURL
        self.downloadURL = downloadURL
    }
    
    init(readMe: ReadmeURLs) {
        self.htmlURL = readMe.htmlURL
        self.downloadURL = readMe.downloadURL
    }
    // func downloadReadMe() {}
}

extension ProjectDetailsViewModel {
    
    // Get readme model
    func getReadMeViewModel(completion :@escaping (ReadMeViewModel?, Error?) -> ()) {
        if let requestRUL = readmeRequestURL {
            self.webservice.getReadmeURLsdetails(from: requestRUL) { (readMeurls, error) in
                DispatchQueue.main.async {
                    if let readME = readMeurls {
                        completion(ReadMeViewModel(readMe: readME), nil)
                    } else {
                        completion(nil, error)
                    }
                }
            }
        }
    }

    // Get image data
    func getProfileImageData(completion :@escaping (Data?, Error?) -> ()) {
        if let url = profileImageURL {
            DispatchQueue.global().async {
                do {
                    let imgData = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        completion(imgData, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
    }
}


