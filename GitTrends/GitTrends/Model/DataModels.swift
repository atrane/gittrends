//
//  DataModels.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.


import Foundation


// Codable Ref: https://hackernoon.com/everything-about-codable-in-swift-4-97d0e18a2999
struct ProjectsList: Codable {
    let projects: [Project]
    
    enum CodingKeys: String, CodingKey {
        case projects = "items"
    }
}

struct Project: Codable {
    let id: Int
    let name: String
    let details: String // description
    let stars: Int //stargazers_count
    let forks: Int //forks_count
    let owner: Owner
    
    var readmeRequestURL: URL? {
        var components = URLComponents()
        components.scheme = RequestKeys.scheme
        components.host = RequestKeys.host
        components.path = RequestKeys.repos + owner.userName + RequestKeys.slash + name + RequestKeys.readme
        return components.url
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case details = "description"
        case stars = "stargazers_count"
        case forks = "forks_count"
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        details = try values.decode(String.self, forKey: .details)
        stars = try values.decode(Int.self, forKey: .stars)
        forks = try values.decode(Int.self, forKey: .forks)
        owner = try values.decode(Owner.self, forKey: .owner)
    }
}

struct Owner: Codable {
    let id: Int
    let userName: String
    let profileURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case profileURL = "avatar_url"
        case id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userName = try values.decode(String.self, forKey: .userName)
        let path = try values.decode(String.self, forKey: .profileURL)
        profileURL = URL(string: path)
        id = try values.decode(Int.self, forKey: .id)
    }
}

struct ReadmeURLs: Codable {
    let htmlURL: String
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case htmlURL = "html_url"
        case downloadURL = "download_url"
    }
}
