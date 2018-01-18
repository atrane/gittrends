//
//  GitTrendsTests.swift
//  GitTrendsTests
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import XCTest
@testable import GitTrends


class GitTrendsTests: XCTestCase {
    
    var mockAPIService: NetworkAPIClientProtocol!
    var viewModel: ProjectListViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIService = MockApiService()
        viewModel = ProjectListViewModel(webservice: mockAPIService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockAPIService = nil
        super.tearDown()
    }
    
    func testProjectListViewModel() {
        
        let expectation = XCTestExpectation(description: "Download https://api.github.com trending projects")
        viewModel.initFetch()
        viewModel.reloadViewModel = { [weak self] in
            
            // List model
            let projectViewModels = self?.viewModel.projectViewModels
            XCTAssert(projectViewModels != nil,  "projectViewModels can't be nil")
            XCTAssert(!projectViewModels!.isEmpty)
            
            let projectViewModel = projectViewModels!.first
            XCTAssert(projectViewModel != nil,  "projectViewModel can't be nil")
            // Individual projectViewModel
            let project = projectViewModel!.project
            XCTAssert(project.id == 22458259)
            XCTAssert(project.name.elementsEqual("Alamofire"))
            XCTAssert(project.details.elementsEqual("Elegant HTTP Networking in Swift"))
            XCTAssert(project.stars == 26623)
            XCTAssert(project.forks == 4678)
            // Owner
            XCTAssert((project.owner.profileURL?.absoluteString.elementsEqual("https://avatars3.githubusercontent.com/u/7774181?v=4")) ?? false)
            XCTAssert(project.owner.userName.elementsEqual("Alamofire"))
            
            // readem = https://api.github.com/repos/:owner/:repo/readme
            let readmeUrl = "https://api.github.com/repos/Alamofire/Alamofire/readme"
            XCTAssert((project.readmeRequestURL?.absoluteString.elementsEqual(readmeUrl)) ?? false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testReadMeModel() {
        
        let expectation = XCTestExpectation(description: "Download https://api.github.com project readme")
        viewModel.initFetch()
        viewModel.reloadViewModel = { [weak self] in
            
            // List model
            let projectViewModels = self?.viewModel.projectViewModels
            XCTAssert(projectViewModels != nil,  "projectViewModels can't be nil")
            XCTAssert(!projectViewModels!.isEmpty)
            
            let projectViewModel = projectViewModels!.first
            XCTAssert(projectViewModel != nil,  "projectViewModel can't be nil")
            let project = projectViewModel!.project
            
            let projectDetialsViewModel = ProjectDetailsViewModel(project: project, webservice: (self?.mockAPIService)!)
            projectDetialsViewModel.getReadMeViewModel(completion: { (readMeVm, error) in
                if let readMeViewModel = readMeVm {
                    XCTAssert(readMeViewModel.htmlURL == "https://github.com/Alamofire/Alamofire/blob/master/README.md")
                    XCTAssert(readMeViewModel.downloadURL == "https://raw.githubusercontent.com/Alamofire/Alamofire/master/README.md")
                } else {
                    // error
                    XCTFail("Cant create ReadMeViewModel..")
                }
            })
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}

// This is mock service to test the API response
class MockApiService: NetworkAPIClientProtocol {
    
    func fetchTrendingProjects(complete: @escaping (_ products: ProjectsList?, _ error: Error? )->() ) {
        // Simulate async behaviour
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1) {
            let json = """
        {
          "items": [
            {
              "id": 22458259,
              "name": "Alamofire",
              "owner": {
                "login": "Alamofire",
                "id": 7774181,
                "avatar_url": "https://avatars3.githubusercontent.com/u/7774181?v=4"
              },
              "description": "Elegant HTTP Networking in Swift",
              "stargazers_count": 26623,
              "forks_count": 4678
            }
          ]
        }
        """
            guard let mockResponseData = json.data(using: .utf8) else {
                complete( nil, NSError(domain: "MockApiService Error", code: -100, userInfo: nil))
                return
            }
            
            do {
                let projectsList = try JSONDecoder().decode(ProjectsList.self, from: mockResponseData)
                
                complete( projectsList, nil)
            } catch  {
                print("error trying to decode JSON, error : \(String(describing: error))")
                complete( nil, error)
                return
            }
        }
    }
    
    // Ref: https://developer.github.com/v3/repos/contents/#get-the-readme
    // GET /repos/:owner/:repo/readme
    func getReadmeURLsdetails(from requestUrl: URL, complete: @escaping (_ readMe: ReadmeURLs?, _ error: Error? )->() ) {
        
        // No need to dispach on other thread for simuation, as this is called from existing mock service for test.
        let json = """
        {
          "html_url": "https://github.com/Alamofire/Alamofire/blob/master/README.md",
          "download_url": "https://raw.githubusercontent.com/Alamofire/Alamofire/master/README.md"
        }
        """
        guard let mockResponseData = json.data(using: .utf8) else {
            complete( nil, NSError(domain: "MockApiService Error", code: -100, userInfo: nil))
            return
        }
        
        do {
            let readmeURLModel = try JSONDecoder().decode(ReadmeURLs.self, from: mockResponseData)
            
            complete( readmeURLModel, nil)
        } catch  {
            print("error trying to decode JSON, error : \(String(describing: error))")
            complete( nil, error)
            return
        }
    }
}



