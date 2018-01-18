//
//  Constants.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import Foundation

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
