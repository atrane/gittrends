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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
