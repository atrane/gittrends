//
//  ProjectDetailsViewController.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import UIKit
import WebKit

class ProjectDetailsViewController: UIViewController {

    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var projectDescriptionLable: UILabel!
    @IBOutlet private weak var starsContanerView: UIView!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var forkslabel: UILabel!
    @IBOutlet private weak var readbMeLabel: UILabel!
    @IBOutlet private weak var readMeWebView: WKWebView!
    @IBOutlet private weak var starViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var forkViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var activityIndicator:UIActivityIndicatorView!
    
    var viewModel: ProjectDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    
    func configureUI() {
        // Setup UI here
        self.title = viewModel.projectName
        activityIndicator.stopAnimating()
        
        userNameLabel.text = viewModel.userName
        projectDescriptionLable.text = viewModel.description
        starsLabel.text = viewModel.stars
        forkslabel.text = viewModel.forks
        readMeWebView.navigationDelegate = self
        
        // Move netork calls to outside
        if let profileImageURL = viewModel.profileImageURL {
            NetworkAPIClient.loadImageFrom(url: profileImageURL) { [weak self] (data, error) in
                if let imgData = data {
                    self?.profileImage.image = UIImage(data: imgData)
                }
            }
        }
        if let requestURL = viewModel.readmeRequestURL {
            let apiService = NetworkAPIClient.shared
            activityIndicator.startAnimating()
            apiService.getReadmeURLsdetails(from: requestURL, complete: { (readMeModel, error) in
                DispatchQueue.main.sync { [weak self] in
                    if let htmlURL = readMeModel?.htmlURL {
                        self?.loadReadMe(withURLString: htmlURL)
                    } else {
                        self?.activityIndicator.startAnimating()
                    }
                }
            })
        }
    }
    
    // Update view rounding on layout change
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        starViewCenterXConstraint.constant = -starsContanerView.bounds.width/4.0
        forkViewCenterXConstraint.constant =  starsContanerView.bounds.width/4.0
        starsContanerView.addRoundCorner(radius: 5.0, color: UIColor.gray)
        
        profileImage.makeRound()
    }
    
    // helper to load URL inside readMeWebView
    private func loadReadMe(withURLString urlString: String) {
        if let readMeURL = URL(string: urlString) {
            let urlRequest = URLRequest(url: readMeURL)
            self.readMeWebView.load(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProjectDetailsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Strat animating
//        activityIndicator.startAnimating()
    }
    // Hide activityIndicator on success, error
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}


