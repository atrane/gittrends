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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    
    func configureUI() {
        // Setup UI here
        self.title = "Details"
        activityIndicator.stopAnimating()
    }
    
    // Update view rounding on layout change
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        starViewCenterXConstraint.constant = -starsContanerView.bounds.width/4.0
        forkViewCenterXConstraint.constant =  starsContanerView.bounds.width/4.0
        starsContanerView.addRoundCorner(radius: 5.0, color: UIColor.gray)
        
        profileImage.makeRound()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
