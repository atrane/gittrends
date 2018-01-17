//
//  ViewModels.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import Foundation


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
    
    init(project: Project) {
        
        projectName = project.name
        profileImageURL = project.owner.profileURL
        userName = project.owner.userName
        description = project.details
        stars = "\(project.stars) Starts"
        forks = "\(project.forks) Forks"
        readmeRequestURL = project.readmeRequestURL
        id = project.id
    }
}
