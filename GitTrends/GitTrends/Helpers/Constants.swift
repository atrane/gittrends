//
//  Constants.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import Foundation

//struct StoryBoardConstants {
//    static let projectDetailSegue = "ProjectDetailSegue"
//    static let projectListCellIdentifier = "ProjectCellIdentifier"
//    
//}

struct RequestKeys {
    static let scheme = "https"
    static let host = "api.github.com"
    static let baseUrl = "https://api.github.com"
    static let searchEndPoint = "/search/repositories?q="
    static let query = "q="
    static let language = "language:"
    static let sort = "&sort:"
    static let order = "&order:"
    
    static let repos = "/repos/"
    static let readme = "/readme"
    
    static let slash = "/"
    static let and = "&"
    
}

struct RequestParameterValue {
    static let sort = "stars"
    static let order = "desc"
    static let language = "swift"
}

struct Responsekeys {
    static let items = "items"
    static let name = "name"
    static let stars = "stargazers_count"
    static let description = "description"
    static let forks = "forks"
    static let owner = "owner"
    static let login = "login"
    static let avatarURL = "avatar_url"
    static let htmlURL = "html_url"
    static let downloadURL = "download_url"
}
