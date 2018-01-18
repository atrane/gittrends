//
//  ProjectListViewCell.swift
//  GitTrends
//
//  Created by A Rane on 17/01/18.
//  Copyright © 2018 A Rane. All rights reserved.
//

import UIKit

class ProjectListViewCell: UITableViewCell {

    @IBOutlet private weak var projectNameLable: UILabel!
    @IBOutlet private weak var starsLable: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func configureCell(with viewModel: ProjectViewModel) {
        self.projectNameLable.text = viewModel.projectName
        self.starsLable.text = viewModel.stars
        self.descriptionLabel.text = viewModel.projectDescription
    }
}
