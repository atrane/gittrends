//
//  NetworkAPIClient.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import Foundation

protocol NetworkAPIClientProtocol {
    func fetchTrendingProjects(complete: @escaping (_ products: ProjectsList?, _ error: Error? )->() )
    func getReadmeURLsdetails(from requestUrl: URL, complete: @escaping (_ readMe: ReadmeURLs?, _ error: Error? )->() )
}

public final class NetworkAPIClient: NetworkAPIClientProtocol {
    
    // MARK: - Instance Properties
    internal let baseURL: String
    internal let session = URLSession.shared
    
    // MARK: - Class Constructors
    public static let shared: NetworkAPIClient = {
        //  add in const file
        let baseUrl = RequestKeys.baseUrl
        return NetworkAPIClient(baseURL: baseUrl)
    }()
    
    // MARK: - Private Constructor
    private init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetchTrendingProjects(complete: @escaping (_ products: ProjectsList?, _ error: Error? )->() ) {
        
        let url = baseURL + RequestKeys.searchEndPoint + RequestKeys.language + RequestParameterValue.language + RequestKeys.sort + RequestParameterValue.sort + RequestKeys.order + RequestParameterValue.order
        
        guard let requestUrl = URL.init(string: url) else {
            print("Error in buiduing URL...")
            complete( nil, nil)
            return
        }
        let urlRequest = URLRequest.init(url: requestUrl)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard let responseData = data else {
                print("Error: did not receive data, error: \(String(describing: error))")
                complete( nil, error)
                return
            }
            
            // parse the result as JSON
            do {
                let projectsList = try JSONDecoder().decode(ProjectsList.self, from: responseData)
                
                complete( projectsList, nil)
            } catch  {
                print("error trying to decode JSON, error : \(String(describing: error))")
                complete( nil, error)
                return
            }
        }
        task.resume()
    }
    
    // Ref: https://developer.github.com/v3/repos/contents/#get-the-readme
    // GET /repos/:owner/:repo/readme
    func getReadmeURLsdetails(from requestUrl: URL, complete: @escaping (_ readMe: ReadmeURLs?, _ error: Error? )->() ) {
        
        let urlRequest = URLRequest.init(url: requestUrl)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard let responseData = data else {
                print("error calling readMe:", error?.localizedDescription ?? "Unknown Error") //  used ! as I am sure for valid error
                complete(nil, error)
                return
            }
            // parse the result as JSON
            do {
                let readMe = try JSONDecoder().decode(ReadmeURLs.self, from: responseData)
                
                complete( readMe, nil)

                
            } catch  {
                print("error trying to decode JSON for readme, error : \(String(describing: error))")
                complete(nil, error)
                return
            }
        }
        task.resume()
    }
}

